package controller

import (
	"github.com/onlythezzz5-spec/zzz-console/web/service"

	"github.com/gin-gonic/gin"
)

type ZZZController struct {
	BaseController

	inboundController     *InboundController
	serverController      *ServerController
	settingController     *SettingController
	xraySettingController *XraySettingController
	serverService         service.ServerService
}

func NewZZZController(g *gin.RouterGroup) *ZZZController {
	a := &ZZZController{}
	a.initRouter(g)
	return a
}

func (a *ZZZController) initRouter(g *gin.RouterGroup) {
	g = g.Group("/panel")
	g.Use(a.checkLogin)

	g.GET("/", a.index)
	g.GET("/inbounds", a.inbounds)
	g.GET("/settings", a.settings)
	g.GET("/xray", a.xraySettings)
	g.GET("/tools", a.tools)
	g.GET("/navigation", a.navigation)

	a.inboundController = NewInboundController(g)
	a.serverController = NewServerController(g, a.serverService)
	a.settingController = NewSettingController(g)
	a.xraySettingController = NewXraySettingController(g)
}

func (a *ZZZController) index(c *gin.Context) {
	html(c, "index.html", "pages.index.title", nil)
}

func (a *ZZZController) inbounds(c *gin.Context) {
	html(c, "inbounds.html", "pages.inbounds.title", nil)
}

func (a *ZZZController) settings(c *gin.Context) {
	html(c, "settings.html", "pages.settings.title", nil)
}

func (a *ZZZController) xraySettings(c *gin.Context) {
	html(c, "xray.html", "pages.xray.title", nil)
}

func (a *ZZZController) tools(c *gin.Context) {
	html(c, "tools.html", "pages.index.title", nil)
}

func (a *ZZZController) navigation(c *gin.Context) {
	html(c, "navigation.html", "pages.navigation.title", nil)
}
