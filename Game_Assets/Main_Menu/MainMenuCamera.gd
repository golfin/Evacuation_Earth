extends Camera2D

var endVect = Vector2(0,0)
var moving = false
var speed = 100


func vector_norm(ve):
	return sqrt(ve.x*ve.x + ve.y*ve.y)

func moveCamera(x,y):
	if not moving:
		endVect = Vector2(x,y)
		moving = true

func _process(delta):
	if moving:
		var diffVect = (endVect - self.global_position)
		var diffVectNorm = vector_norm(diffVect)
		var velVec = (diffVect/diffVectNorm)*speed
		if diffVectNorm < 1.0:
			endVect = Vector2(0,0)
			moving = false
		else:
			self.move_local_x(velVec.x*delta)
			self.move_local_y(velVec.y*delta)

func isMoving():
	return moving