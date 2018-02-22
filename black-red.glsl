// Try turning all the pixels on the left half of the screen black,
// and red on the right half.
// Note: try enlarging the screen.
void mainImage(
  out vec4 fragColor,
  in vec2 fragCoord    // pixel's x, y, and z (in 3D)
)
{
  // Obtain coordinates of the current pixel.
  vec2 xy = fragCoord.xy;

  // Divide coordinates by the screen resolution.
  xy.x = xy.x / iResolution.x;
  xy.y = xy.y / iResolution.y;

  // x is 0 for the leftmost pixel, and 1 for the rightmost one.
  fragColor = vec4(0, 0, 0, 1.0);  // black
  if (xy.x > 0.5) {
    fragColor.r = 1.0;  // set red component to 1
  }
}
