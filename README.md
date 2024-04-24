# editor_objects_dumper

This is a MTA:SA Lua script designed to facilitate dumping objects from the loaded editor map to editor GUI bookmarks.

## Requirements

- Unzipped `editor_gui` resource that is in `[editor]` resources folder.
- `general.ModifyOtherObjects`, `function.startResource`, `function.stopResource` granted permissions to `editor_objects_dumper` resource

## Installation

1. [Download](https://github.com/Luminaire1337/editor_objects_dumper/archive/refs/heads/master.zip) resource from GitHub and place it in `resources` folder.
2. Ensure the `editor_gui` resource is installed and unzipped.
3. Start the resource by using `/start editor_objects_dumper`.

## Usage

1. In-game, use the `/dumpobjects <categoryName>` command to dump objects from the editor.
2. Ensure you specify a valid category name.
3. Objects will be dumped into an internal XML file and editor GUI will be restarted.

## License

This project is licensed under the [MIT License](https://github.com/Luminaire1337/editor_objects_dumper/blob/master/LICENSE).
