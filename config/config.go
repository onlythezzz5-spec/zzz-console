package config

import (
	_ "embed"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"runtime"
	"strings"
)

//go:embed version
var version string

//go:embed name
var name string

type LogLevel string

const (
	Debug  LogLevel = "debug"
	Info   LogLevel = "info"
	Notice LogLevel = "notice"
	Warn   LogLevel = "warn"
	Error  LogLevel = "error"
)

func GetVersion() string {
	return strings.TrimSpace(version)
}

func GetName() string {
	return strings.TrimSpace(name)
}

func GetLogLevel() LogLevel {
	if IsDebug() {
		return Debug
	}
	logLevel := firstEnv("ZZZ_LOG_LEVEL", "XUI_LOG_LEVEL")
	if logLevel == "" {
		return Info
	}
	return LogLevel(logLevel)
}

func IsDebug() bool {
	return firstEnv("ZZZ_DEBUG", "XUI_DEBUG") == "true"
}

func GetBinFolderPath() string {
	binFolderPath := firstEnv("ZZZ_BIN_FOLDER", "XUI_BIN_FOLDER")
	if binFolderPath == "" {
		binFolderPath = "bin"
	}
	return binFolderPath
}

func getBaseDir() string {
	exePath, err := os.Executable()
	if err != nil {
		return "."
	}
	exeDir := filepath.Dir(exePath)
	exeDirLower := strings.ToLower(filepath.ToSlash(exeDir))
	if strings.Contains(exeDirLower, "/appdata/local/temp/") || strings.Contains(exeDirLower, "/go-build") {
		wd, err := os.Getwd()
		if err != nil {
			return "."
		}
		return wd
	}
	return exeDir
}

func GetDBFolderPath() string {
	dbFolderPath := firstEnv("ZZZ_DB_FOLDER", "XUI_DB_FOLDER")
	if dbFolderPath != "" {
		return dbFolderPath
	}
	if runtime.GOOS == "windows" {
		return getBaseDir()
	}
	return "/etc/zzz"
}

func GetDBPath() string {
	return fmt.Sprintf("%s/%s.db", GetDBFolderPath(), GetName())
}

func GetLogFolder() string {
	logFolderPath := firstEnv("ZZZ_LOG_FOLDER", "XUI_LOG_FOLDER")
	if logFolderPath != "" {
		return logFolderPath
	}
	if runtime.GOOS == "windows" {
		return filepath.Join(".", "log")
	}
	return "/var/log"
}

func copyFile(src, dst string) error {
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()

	out, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer out.Close()

	_, err = io.Copy(out, in)
	if err != nil {
		return err
	}

	return out.Sync()
}

func firstEnv(names ...string) string {
	for _, name := range names {
		if value := os.Getenv(name); value != "" {
			return value
		}
	}
	return ""
}

func init() {
	newDBFolder := GetDBFolderPath()
	newDBPath := fmt.Sprintf("%s/%s.db", newDBFolder, GetName())
	if _, err := os.Stat(newDBPath); err == nil {
		return
	}

	if runtime.GOOS != "windows" {
		_ = os.MkdirAll(newDBFolder, 0750)
	}

	legacyPaths := []string{
		filepath.Join(newDBFolder, "x-ui.db"),
		"/etc/x-ui/x-ui.db",
	}
	if runtime.GOOS == "windows" {
		legacyPaths = append([]string{filepath.Join(getBaseDir(), "x-ui.db")}, legacyPaths...)
	}

	for _, oldDBPath := range legacyPaths {
		if _, err := os.Stat(oldDBPath); err != nil {
			continue
		}
		if copyFile(oldDBPath, newDBPath) == nil {
			return
		}
	}
}
