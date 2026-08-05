if (pode_dar_dano) {

    // DAR DANO
    other.vida -= 10;

    // CALCULAR DIREÇÃO OPOSTA
    var ang = point_direction(other.x, other.y, x, y);

    // APLICAR FORÇA DE RECUO
    knockback_timer = room_speed * 0.3;

    knockback_x = lengthdir_x(8, ang);
    knockback_y = lengthdir_y(8, ang);

    dano_cooldown = room_speed;
}