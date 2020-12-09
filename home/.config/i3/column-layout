#!/usr/bin/env python3
#
# Automatically splits windows so workspaces are laid out in 2 columns.

from i3ipc import Connection, Event

COLUMNS = 2

def move_container (con1, con2):
    con2.command("mark __column-layout");
    con1.command("move window to mark __column-layout")
    con2.command("unmark __column-layout");

def layout (i3, event):
    if event.change == "close":
        for reply in i3.get_workspaces():
            if reply.focused:
                workspace = i3.get_tree().find_by_id(reply.ipc_data["id"]).workspace()

                if len(workspace.nodes) == 1 and len(workspace.nodes[0].nodes) == 1:
                    child = workspace.nodes[0].nodes[0]
                    move_container(child, workspace)
    else:
        window = i3.get_tree().find_by_id(event.container.id)
        if window is not None:
            workspace = window.workspace()
            if workspace is not None and len(workspace.nodes) >= COLUMNS:
                for node in workspace.nodes:
                    if node.layout != "splitv":
                        node.command("splitv")

i3 = Connection()
i3.on(Event.WINDOW_NEW, layout)
i3.on(Event.WINDOW_CLOSE, layout)
i3.on(Event.WINDOW_MOVE, layout)
i3.main()
