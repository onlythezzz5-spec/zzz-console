from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parents[1]


def read(relative: str) -> str:
    path = ROOT / relative
    if not path.is_file():
        raise AssertionError(f"missing file: {relative}")
    return path.read_text(encoding="utf-8")


def require(relative: str, *needles: str) -> None:
    content = read(relative)
    for needle in needles:
        if needle not in content:
            raise AssertionError(f"{relative}: missing {needle!r}")


def main() -> int:
    critical_console_files = (
        "main.go",
        "web/web.go",
        "web/controller/inbound.go",
        "web/controller/setting.go",
        "web/controller/xray_setting.go",
        "web/service/inbound.go",
        "web/service/xray.go",
        "web/html/inbounds.html",
        "web/html/settings.html",
        "web/html/xray.html",
        "install.sh",
        "x-ui.sh",
    )
    for relative in critical_console_files:
        if not (ROOT / relative).is_file():
            raise AssertionError(f"console core file lost: {relative}")

    kejilion_root = ROOT / "tools" / "kejilion"
    kejilion_files = [path for path in kejilion_root.rglob("*") if path.is_file()]
    if len(kejilion_files) < 70:
        raise AssertionError(
            f"server toolkit bundle incomplete: expected at least 70 files, got {len(kejilion_files)}"
        )
    for relative in (
        "tools/kejilion/kejilion.sh",
        "tools/kejilion/LICENSE",
        "tools/kejilion/README.md",
        "tools/kejilion/cn/kejilion.sh",
        "tools/kejilion/en/kejilion.sh",
    ):
        if not (ROOT / relative).is_file():
            raise AssertionError(f"server toolkit file lost: {relative}")

    require(
        "web/controller/xui.go",
        'g.GET("/inbounds", a.inbounds)',
        'g.GET("/settings", a.settings)',
        'g.GET("/xray", a.xraySettings)',
        'g.GET("/tools", a.tools)',
        'g.GET("/navigation", a.navigation)',
    )
    if 'g.GET("/servers"' in read("web/controller/xui.go"):
        raise AssertionError("fake remote-server page route still exists")
    require(
        "web/html/component/aSidebar.html",
        "ZZZ Console",
        "panel/inbounds",
        "panel/settings",
        "panel/xray",
        "panel/tools",
        "panel/navigation",
    )
    if "panel/servers" in read("web/html/component/aSidebar.html"):
        raise AssertionError("fake remote-server navigation entry still exists")
    if (ROOT / "web/html/servers.html").exists():
        raise AssertionError("fake remote-server page still exists")

    require("web/html/tools.html", "x-ui tools", "内置完整服务器工具模块")
    require(
        "web/html/inbounds.html",
        "createVlessRealityInbound",
        "createVlessXhttpRealityInbound",
        "createVlessTlsEncryptionInbound",
        "oneClickPreset",
        "linkHistory",
    )
    require(
        "web/service/tgbot.go",
        "sendOneClickOptions",
        "remoteCreateOneClickInbound",
        "buildRealityInbound",
        "buildXhttpRealityInbound",
        "buildTlsInbound",
        "SendOneClickConfig",
    )
    require("x-ui.sh", "zzz_tools()", '"tools")', "服务器工具箱（完整建站功能）")
    require(
        ".github/workflows/release.yml",
        "cp -r tools x-ui/",
        "Copy-Item -Path ..\\tools -Destination . -Recurse",
    )
    require("Dockerfile", "COPY --from=builder /app/tools /app/tools")
    require("NOTICE.md", "Copyright (C) 2026 zzz", "X-Panel", "Kejilion")
    require(
        "README.md",
        "一键安装",
        "第一次使用",
        "功能总览",
        "docs/INSTALLATION.md",
        "docs/FEATURES.md",
        "项目维护者：**zzz**",
    )
    for relative in (
        "docs/INSTALLATION.md",
        "docs/FEATURES.md",
        "docs/OPERATIONS.md",
        "docs/TROUBLESHOOTING.md",
    ):
        read(relative)

    install_script = read("install.sh")
    if "onlythezzz5-spec/zzz-console" not in install_script:
        raise AssertionError("installer still targets the upstream release")
    for forbidden in (
        "install_paid_version",
        "auth.x-panel.vip",
        "get_hwid",
        "License Key",
        "免费基础版",
    ):
        if forbidden in install_script:
            raise AssertionError(f"installer still contains removed paywall logic: {forbidden}")

    public_runtime = "\n".join(
        read(relative)
        for relative in (
            "README.md",
            "install.sh",
            "x-ui.sh",
            "web/html/index.html",
            "web/html/inbounds.html",
            "web/html/navigation.html",
            "web/html/tools.html",
            "web/service/tgbot.go",
        )
    )
    for forbidden in (
        "Buy_ShouQuan_Bot",
        "auth.x-panel.vip",
        "付费Pro版",
        "授权码购买",
        "XUI_CN",
        "t.me/is_Chat_Bot",
    ):
        if forbidden in public_runtime:
            raise AssertionError(f"public runtime still contains upstream promotion: {forbidden}")

    version = read("ZZZ_VERSION").strip()
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        raise AssertionError(f"invalid ZZZ_VERSION: {version!r}")

    print(
        "PASS: ZZZ Console core, full one-click configuration, documentation, "
        "toolkit packaging and promotion cleanup verified"
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except AssertionError as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        raise SystemExit(1)
