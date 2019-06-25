void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Coordinates of the current pixel.
    vec2 xy = fragCoord.xy;

    // Divide coordinates by the screen resolution.
    xy.x = xy.x / iResolution.x;
    xy.y = xy.y / iResolution.y;

    fragColor = vec4(sin(mod(100000.0 + iGlobalTime, 1000000.0) * (1.0 + xy.x) * (1.0 + xy.y)), 0, 0, 1.0);
}
