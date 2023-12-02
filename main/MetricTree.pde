class MetricTree {
  int id = -1;
  float radius;
  MetricTree mtInside = null;
  MetricTree mtOutside = null;

  void insert(int newId, float _radius) {
   
    if (id == -1) {
      this.id = newId;
      this.radius = _radius;
      return;
    }
 
    float d = dist(points[newId].x, points[newId].y, points[newId].z, points[this.id].x, points[this.id].y, points[this.id].z);
    if (d < this.radius) {
      if (this.mtInside == null) this.mtInside = new MetricTree();
      this.mtInside.insert(newId, this.radius / 2);
    } else {
      if (this.mtOutside == null) this.mtOutside = new MetricTree();
      this.mtOutside.insert(newId, this.radius / 2);
    }
  }

  void search(PVector pos, float searchRadius, IntList neighbours) {
    if (this.id == -1) return;
    float d = dist(pos.x, pos.y, pos.z, points[this.id].x, points[this.id].y, points[this.id].z);
    if (d < searchRadius) neighbours.append(this.id);
    if (d < this.radius) {
      if (this.mtInside != null)
        this.mtInside.search(pos, searchRadius, neighbours);
      if ((this.mtOutside != null) && (d + searchRadius > this.radius))
        this.mtOutside.search(pos, searchRadius, neighbours);
    } else {
      if (this.mtOutside != null)
        this.mtOutside.search(pos, searchRadius, neighbours);
      if ((this.mtInside != null) && (d < this.radius + searchRadius))
        this.mtInside.search(pos, searchRadius, neighbours);
    }
  }
}
