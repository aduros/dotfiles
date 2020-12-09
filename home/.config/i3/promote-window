#!/usr/bin/env python3
#
# Promotes the focused window by swapping it with the largest window.

from i3ipc import Connection, Event

def find_biggest_window (container):
    max_leaf = None
    max_area = 0
    for leaf in container.leaves():
        rect = leaf.rect
        area = rect.width * rect.height
        if not leaf.focused and area > max_area:
            max_area = area
            max_leaf = leaf
    return max_leaf

i3 = Connection()

for reply in i3.get_workspaces():
    if reply.focused:
        workspace = i3.get_tree().find_by_id(reply.ipc_data["id"])
        master = find_biggest_window(workspace)
        i3.command("swap container with con_id %s" % master.id)
