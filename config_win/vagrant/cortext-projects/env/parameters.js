dashboardConfig =
{
    services: {
        Storage: {
            name: "Cortext Assets",
            url: "http://assets.cortext.dev:8080",
            getDocument: "/docs",
            callback: "http://127.0.0.1:3000"
        },
        Identity: {
            name: "Cortext Auth",
            urlAuth: "http://auth.cortext.dev:8080/auth",
	    urlGrant: "http://auth.cortext.dev/auth/grant",
            urlAccess: "http://auth.cortext.dev/auth/access",
            urlSubscribe: "http://auth.cortext.dev:8080/user/register",
            urlEdit: "http://auth.cortext.dev:8080/user",
	        callback: "http://127.0.0.1:3000",
            account: {
                service: "cortext",
                clientId: "cortext-dashboard",
                secret: "c0rt3xt"
            }
        },
        Jobs: {
            name: "Cortext Manager",
            callback: "http://127.0.0.1:3000",
            callback_json:"http://127.0.0.1:3000/api/analysis",
            url: "http://manager.cortext.dev:8080" 
        },
        Viz: {
            pdf: "/view/pdf/",
            json: "http://graphs.cortext.dev:8080/open/",
            csv: "/view/csv/",
            gexf: "http://documents.cortext.dev:8080/lib/mapexplorer/explorerjs.html?file="
        },
        Api: {
            url: "http://127.0.0.1:3000/api",
            createElement: "/elements",
            createDocument: "/documents",
            createAnalysis: "/analysis"
	}
    },
    common: {
        callback : "http://127.0.0.1:3000",
        urlCGU: "http://auth.cortext.dev:8080/cgu",
        urlCredits: "http://auth.cortext.dev:8080/credits",
        urlMentions: "http://auth.cortext.dev:8080/mentions-legales",
        urlContact: "http://www.cortext.net/contact",
        urlManagerv1: "http://manager.cortext.net",
        refreshRate : 5000
    },
    design: {
        activateHelp: true
    },
    mail: {
        smtp: "smtp://localhost:25"
    }
};
      
