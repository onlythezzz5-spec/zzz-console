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
    critical_xpanel_files = (
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
    for relative in critical_xpanel_files:
        if not (ROOT / relative).is_file():
            raise AssertionError(f"X-Panel baseline file lost: {relative}")

    kejilion_root = ROOT / "tools" / "kejilion"
    kejilion_files = [path for path in kejilion_root.rglob("*") if path.is_file()]
    if len(kejilion_files) < 70:
        raise AssertionError(
            f"Kejilion bundle incomplete: expected at least 70 files, got {len(kejilion_files)}"
        )
    for relative in (
        "tools/kejilion/kejilion.sh",
        "tools/kejilion/LICENSE",
        "tools/kejilion/README.md",
        "tools/kejilion/cn/kejilion.sh",
        "tools/kejilion/en/kejilion.sh",
    ):
        if not (ROOT / relative).is_file():
            raise AssertionError(f"Kejilion baseline file lost: {relative}")

    require(
        "web/controller/xui.go",
        'g.GET("/inbounds", a.inbounds)',
        'g.GET("/settings", a.settings)',
        'g.GET("/xray", a.xraySettings)',
        'g.GET("/tools", a.tools)',
    )
    require(
        "web/html/component/aSidebar.html",
        "ZZZ Console",
        "panel/inbounds",
        "panel/settings",
        "panel/xray",
        "panel/tools",
    )
    require("web/html/tools.html", "x-ui tools", "完整保留 Kejilion")
    require("x-ui.sh", "zzz_tools()", '"tools")', "服务器工具箱（完整建站功能）")
    require(
        ".github/workflows/release.yml",
        "cp -r tools x-ui/",
        "Copy-Item -Path ..\\tools -Destination . -Recurse",
    )
    require("Dockerfile", "COPY --from=builder /app/tools /app/tools")
    require("NOTICE.md", "Copyright (C) 2026 zzz", "X-Panel", "Kejilion")

    install_script = read("install.sh")
    if "onlythezzz5-spec/zzz-console" not in install_script:
        raise AssertionError("installer still targets the upstream release")

    version = read("ZZZ_VERSION").strip()
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        raise AssertionError(f"invalid ZZZ_VERSION: {version!r}")

    print(
        "PASS: X-Panel core retained, Kejilion bundle retained, "
        "ZZZ branding/tool entry/release packaging wired"
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except AssertionError as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        raise SystemExit(1)
