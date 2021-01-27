// Script that runs on startup in Tridactyl's background context

// Display desktop notifications when downloads complete
browser.downloads.onChanged.addListener(async item => {
    if (item.state.current == item.state.previous) {
        return; // No change
    }

    var download = (await browser.downloads.search({id: item.id}))[0];
    var filename = download.filename.replace(/.*\//, "");

    switch (item.state.current) {
    case "complete":
        var command = "notify-send -i download";
        var message = await tri.excmds.shellescape("Downloaded "+filename);
        tri.native.run(command+" "+message);
        break;

    case "interrupted":
        var command = "notify-send -i dialog-no";
        var message = await tri.excmds.shellescape("Error downloading "+filename);
        tri.native.run(command+" "+message);
        break;
    }
});

window.__custom_tabAudio = async function () {
    const tabs = await browser.tabs.query({ currentWindow: true, hidden: false, audible: true });
    if (tabs.length > 0) {
        return browser.tabs.update(tabs[0].id, { active: true });
    }
}
