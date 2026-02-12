var container;

function ControlReady() {
    container = document.createElement("pre");
    container.style.whiteSpace = "pre-wrap";
    container.style.fontFamily = "Consolas, monospace";
    container.style.padding = "10px";
    container.style.height = "100vh";
    container.style.width = "100%";
    container.style.overflow = "auto";
    container.style.backgroundColor = "#f5f5f5";
    container.style.margin = "0";
    document.body.appendChild(container);
    console.log("Container initialized successfully");
}

Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("ControlReady", []);


function SetText(apiText) {
    const container = document.createElement("pre");
    container.style.whiteSpace = "pre-wrap";
    container.style.fontFamily = "Consolas, monospace";
    container.style.padding = "10px";
    container.style.height = "100vh";
    container.style.width = "100%";
    container.style.overflow = "auto";
    container.style.backgroundColor = "#f5f5f5";
    container.style.margin = "0";
    container.textContent = apiText;
    container.style.color = "#ad1212";
    document.body.appendChild(container);
        console.log("Container initialized successfully");
    if (!container) {
        console.error("Container not initialized");
        return;
    }
    if (!apiText) {
        console.warn("No text provided to SetText");
        return;
    }
    console.log("Setting text:", apiText);
    document.body.innerHTML = apiText;
    document.body.innerHTML.textContent.color = "#ad1212";
    document.body.innerHTML.style.color = "#ad1212";
}

function LoadApiResult(apiText) {
    const container = document.createElement("pre");
    container.style.whiteSpace = "pre-wrap";
    container.style.fontFamily = "Consolas, monospace";
    container.style.padding = "10px";
    container.style.height = "100vh";
    container.style.width = "100%";
    container.style.overflow = "auto";
    container.style.backgroundColor = "#f5f5f5";
    container.style.margin = "0";
    container.textContent = apiText;
    container.style.color = "#ad1212";
    document.body.appendChild(container);
        console.log("Container initialized successfully");
    if (!container) {
        console.error("Container not initialized");
        return;
    }
    if (!apiText) {
        console.warn("No text provided to SetText");
        return;
    }
    console.log("Setting text:", apiText);
    document.body.innerHTML = apiText;
    document.body.innerHTML.textContent.color = "#ad1212";
    document.body.innerHTML.style.color = "#ad1212";
}
