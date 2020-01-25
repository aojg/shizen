extends Spatial

var tree_attribs: Array = []
var tree_count: int = 0


var ico: Spatial = null
var planet: Spatial = null

func _ready() -> void:
    self.ico = self.get_node("../Planet/Icosphere")
    self.planet = self.get_node("../Planet")
    $Timer.connect("timeout", self, "_on_timeout")

    for i in range(self.ico.get_tri_count()):
        self.tree_attribs.append({})


func _physics_process(delta: float) -> void:
    pass
    

func add_tree(tri_idx: int, attribs: Array) -> void:
    var bar: Dictionary = {
        "ideal_temp" : attribs[0]
    }
    self.tree_attribs[tri_idx] = bar
    self.tree_count += 1
    self.planet.set_tri_info(tri_idx, "occupied", 1)
    if tree_count == 1:
        $Timer.start()

func create_children() -> void:
    for i in range(tree_attribs.size()):
        if not tree_attribs[i].empty():
            var idces: Array = self.ico.get_neighbours(i)
            for idx in idces:
                if self.planet.get_tri_info(idx, "occupied") == 0 && randf() > 0.5:
                    self.add_tree(idx, [5])
            self.tree_attribs[i] = {}
            self.planet.set_tri_info(i, "occupied", 0)
            self.tree_count -= 1


func draw_multimesh() -> void:
    var ico: Spatial = get_node("../Planet/Icosphere")
    $MultiMeshInstance.multimesh.set_instance_count(self.tree_count)
    var count: int = 0
    for i in range(self.tree_attribs.size()):
        if not self.tree_attribs[i].empty():
            var t: Transform = Transform()
            var pos: Vector3 = ico.get_tri_center(i)
            var normal: Vector3 = ico.get_surface_normal(i)
            var look_dir: Vector3 = normal.cross(Vector3.ONE)
            t = t.translated(pos)
            t = t.looking_at(t.origin + look_dir * 100.0, normal)
            $MultiMeshInstance.multimesh.set_instance_transform(count, t)
            count += 1
   

func _on_timeout() -> void:
    self.create_children()
    self.draw_multimesh()


