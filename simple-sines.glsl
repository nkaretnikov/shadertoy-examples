// Public domain.

// Colors.
const vec3 black = vec3(0.);
const vec3 red   = vec3(1., 0., 0.);
const vec3 green = vec3(0., 1., 0.);
const vec3 blue  = vec3(0., 0., 1.); 

// Smooth sine.
vec3 sSin(
    vec3 color,
    float x, float y, float pos, float width, float blur,
    float amp, float freq, float speed)
{   
    pos = pos - (width / 2.);  // move the center in between two 'sin's
    float t = x * freq + iTime * speed;
    float f = amp * sin(t);
    float inter = y;  // value for interpolation
    
    // XXX: Need to find a parallel curve to the sine wave to make it
    // look good with 'freq' > 1.
    // https://en.wikipedia.org/wiki/Parallel_curve
    
    float res = smoothstep(
        pos        - f,
        pos + blur - f,
        inter);
    res -= smoothstep(
        pos + width - blur - f,
        pos + width        - f,
        inter);

    return res * color;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // Normalized pixel coordinates (from 0 to 1).
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    // Move 0.0 to the center.
    uv -= .5;
    
    // Account for the screen ratio.
    uv.x *= iResolution.x / iResolution.y;  
    
    // Output color.
    vec3 color = black;
      
    color += blue;
    
    float pos   = 0.;
    float width = .1;
    float blur  = .01;
    float amp   = .45;
    float freq  = sin(iTime * .5) * 10.;
    float speed = 4.;
    
    // Horizontal sine.
    color -= sSin(blue - red,
                  uv.x, uv.y, pos, width, blur, amp, freq, speed);
    // Vertical sine.
    color -= sSin(blue + red - green,
                  uv.y, uv.x, pos, width, blur, amp, freq, speed);    
    
    // Circles:    uv.x * uv.x, uv.y * uv.y
    // Hyperbolas: uv.x * uv.y, uv.x * uv.y                  

    // Output to screen.
    fragColor = vec4(color, 1.);
}
