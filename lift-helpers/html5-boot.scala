 
    // Use HTML5 template parsing & rendering instead of default XHTML
    LiftRules.htmlProperties.default.set((r: Req) =>
        new Html5Properties(r.userAgent))

