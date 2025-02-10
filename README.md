# shizen

This is an old game prototype that runs on Godot v3.2.
[![demo_video](https://img.youtube.com/vi/HJakXZglo8Q/0.jpg)](https://www.youtube.com/watch?v=HJakXZglo8Q)

## v0.11a

**Changelog**

* Added some UI that displays information about triangles on hover, such as temperature.
* Added support for different temperature modes including celsius, fahrenheit, and kelvin. 
* Added two input modes: inspection and plant mode. In inspection mode you can inspect triangles to obtain certain information about their properties, and in plant mode you can plant and harvest trees.
* Added ability to grow multiple trees at once in plant mode.
* Added mesh highlighting which makes the triangle that your mouse is over a different colour.

**Bug Fixes**

* Fixed an issue where you could zoom inside the planet and zoom away from the planet forever. Zoom distances are now capped to prevent this.


## v0.10a
* Reverted changes with MultiMeshes. 
* A bit of project refactoring has been done, i.e. renaming and such.
* Implemented an InputManager.gd script that handles input.
* Trees no longer spread freely, instead they must be planted.
* Trees can now be removed from the planet.
* Once fully grown trees will not die. They have to be removed manually.
* Working on making the project feel more like a game and less like a simulation.


## v0.09a 
Made large changes to how crops work. They're not fully re-implemented yet. There include:
* Utilising MultiMeshes for better runtime performance.
* Instead of calculating adjacent triangles at runtime they're now calculated for all triangles upon game launch. This massively improves performance.

## v0.08a

* Refactored a lot in the CropController.gd script, namely how crop attributes work.
* Triangles can now have unique "attributes" that affect crop success.
* Crop and triangle attributes now use a normal distribution instead of pure random assignment.
* Triangles are now coloured based on their temperature.
* Added some crop colours (no longer created 100s of SpatialMaterials, should speed up performance a little).
* Fixed bug where crop children couldn't go on their parent's children (wasn't actually fixed in v0.07a).


## v0.07a

* Multiple crops can no longer grow on a single triangle.
* Fixed issue with child crops not being able to grow on triangle their parent was previously on.
* Created a Planet scene for more organised project management.
* Switched from using vertex indices to triangle indices in some scripts (tri_idx / 3 = v_idx)
* Other small refactoring changes.


## v0.06a

* Crop children can now grow on the adjacent triangles to their parent.
* Fixed an issue with normals on crop children. They now can now grow properly on irregular terrain.
* Created a LineDrawer spatial that allows to draw 3D lines for debug purposes.

## v0.05a
* Refactored some of the Planet.gd class.
* Renamed Planet.gd to Icosphere.gd.
* Renamed the project from 'farm' to 'shizen'.
* Removed some empty/unused classes from the project.
* Added a Materials folder to the project.

## v0.04a

* Implemented functionality to locate the neighbouring triangles of a given triangle in the icosphere mesh.

## v0.03a

* Planet mesh's triangles can now be painted.

## v0.02a

* Colour is now a cosmetic property (i.e. it doesn't affect a crop's growing properties).
* Fixed problem with camera not actually rotating around the planet.
* Planet is now an icosphere, so individual mesh triangles can have varying colours.

## v0.01a

* Added some simplistic UI to display properties about the world, e.g. the global temperature and number of entities.
* Planet now changes colour based on the temperature (redder with warmer temperatures, bluer with colder ones).
* Beginning to work on better proper crop property implementation.
* Started developing a wiki explaining aspects of the game, mainly for my own sake.
