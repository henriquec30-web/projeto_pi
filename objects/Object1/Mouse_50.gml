if (cooldown <= 0) {

    var ang = point_direction(x, y, mouse_x, mouse_y);

    var b = instance_create_layer(x, y, "Instances", Object2);

    b.direction = ang;
    b.speed = 9;

    cooldown = room_speed / 2;
}