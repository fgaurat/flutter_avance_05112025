// Flutter Fragment Shader (GLSL ES 3.0 compatible)
#version 320 es
precision mediump float;

// Uniforms : Flutter envoie ces valeurs depuis Dart
layout (location = 0) uniform vec2 u_resolution; // largeur, hauteur en px
layout (location = 1) uniform float u_time;      // secondes écoulées
layout (location = 2) uniform vec2 u_touch;      // position touch (px), (-1,-1) si inactif

out vec4 fragColor;

float ripple(vec2 p, vec2 center, float t) {
    float d = distance(p, center);
    // onde sinusoïdale qui se propage avec amortissement
    return 0.5 + 0.5 * sin(10.0 * d - 4.0 * t) * exp(-0.5 * d);
}

void main() {
    // Normalise coords dans [0,1]
    vec2 uv = gl_FragCoord.xy / u_resolution;
    // Centre
    vec2 c = vec2(0.5, 0.5);

    // Onde centrale
    float w = ripple(uv, c, u_time);

    // Onde au doigt si présent
    vec2 touchUV = u_touch.x < 0.0 ? c : (u_touch / u_resolution);
    float w2 = ripple(uv, touchUV, u_time);

    // Couleurs : mélange dégradé + ondes
    vec3 base = mix(vec3(0.07, 0.10, 0.25), vec3(0.10, 0.35, 0.65), uv.y);
    vec3 col  = base + 0.25 * vec3(w) + 0.25 * vec3(w2);

    fragColor = vec4(col, 1.0);
}