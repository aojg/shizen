# shizen

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
