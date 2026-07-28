package web

import (
	"html/template"
	"testing"
)

func TestEmbeddedTemplatesParse(t *testing.T) {
	server := &Server{}
	templates, err := server.getHtmlTemplate(template.FuncMap{
		"i18n": func(key string, params ...string) string {
			return key
		},
	})
	if err != nil {
		t.Fatalf("parse embedded templates: %v", err)
	}
	for _, name := range []string{
		"login.html",
		"index.html",
		"inbounds.html",
		"settings.html",
		"xray.html",
		"tools.html",
	} {
		if templates.Lookup(name) == nil {
			t.Fatalf("embedded template missing: %s", name)
		}
	}
}
