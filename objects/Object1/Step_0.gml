// ==========================
// DIREÇÃO DE MOVIMENTO
// ==========================
var mx = 0;
var my = 0;

if (keyboard_check(ord("W"))) my -= 1;
if (keyboard_check(ord("S"))) my += 1;
if (keyboard_check(ord("A"))) mx -= 1;
if (keyboard_check(ord("D"))) mx += 1;

if (mx != 0 || my != 0) {
    move_dir = point_direction(0, 0, mx, my);
}

// ==========================
// MORTE
// ==========================
if (vida <= 0) {
    instance_destroy();
}

// ==========================
// ATIVAR DASH
// ==========================
if (keyboard_check_pressed(vk_space) 
    && dash_timer <= 0 
    && dash_cooldown_timer <= 0
    && (mx != 0 || my != 0)) 
{
    dash_timer = dash_duration;
    dash_cooldown_timer = dash_cooldown;
}
// ==========================
// MOVIMENTO
// ==========================
var speed_normal = 3;

if (dash_timer > 0) {

    dash_timer--;

    var dx = lengthdir_x(dash_speed, move_dir);
    var dy = lengthdir_y(dash_speed, move_dir);

    // colisão eixo X
    if (!place_meeting(x + dx, y, obj_inimigo)) {
        x += dx;
    }

    // colisão eixo Y
    if (!place_meeting(x, y + dy, obj_inimigo)) {
        y += dy;
    }

} else {

    // movimento normal com colisão
    if (mx != 0) {
        if (!place_meeting(x + mx * speed_normal, y, obj_inimigo)) {
            x += mx * speed_normal;
        }
    }

    if (my != 0) {
        if (!place_meeting(x, y + my * speed_normal, obj_inimigo)) {
            y += my * speed_normal;
        }
    }
}

// ==========================
// COOLDOWN DE TIRO
// ==========================
if (cooldown > 0) {
    cooldown -= 1;
}
// ==========================
// COOLDOWN DO DASH
// ==========================
if (dash_cooldown_timer > 0) {
    dash_cooldown_timer--;
}
