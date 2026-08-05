// =============================
// MORRER
// =============================
if (vida <= 0) {
    instance_destroy();
    exit;
}

// =============================
// DEFINIR VELOCIDADE (BERSERK)
// =============================
if (vida < 31) {
    v = v_berserk;
} else {
    v = v_base;
}

// =============================
// COOLDOWN DE DANO
// =============================
if (dano_cooldown > 0) {
    dano_cooldown--;
    pode_dar_dano = false;
} else {
    pode_dar_dano = true;
}

// =============================
// KNOCKBACK
// =============================
if (knockback_timer > 0) {

    knockback_timer--;

    x += knockback_x;
    y += knockback_y;

    exit;
}
// =============================
// SEGUIR PLAYER (SE EXISTIR)
// =============================
if (instance_exists(Object1)) {

    var dist = point_distance(x, y, Object1.x, Object1.y);

    if (dist < 600) {

        var ang = point_direction(x, y, Object1.x, Object1.y);

        var mov_x = lengthdir_x(v, ang);
        var mov_y = lengthdir_y(v, ang);

        x += mov_x;
        y += mov_y;
    }
}