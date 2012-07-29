#version 120

uniform float alpha;

void main()
{
    // Calculate distance to circle center
    float d = distance(gl_TexCoord[0].xy, vec2(0.5, 0.5));

    // Discard fragments regarding the distance to the center.
    if( d > 0.5 || d < 0.2)
        discard;

    gl_FragColor = vec4(1.0, 0.0, 0.0, alpha * (1 - abs(0.3 - d) / 0.05));
}