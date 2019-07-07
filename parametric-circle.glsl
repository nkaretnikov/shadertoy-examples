// Public domain.

// Constants.
const float pi = 3.1415;   

// Colors.
const vec3 black = vec3(0.);
const vec3 white = vec3(1.);
const vec3 red   = vec3(1., 0., 0.);
const vec3 green = vec3(0., 1., 0.);
const vec3 blue  = vec3(0., 0., 1.);

// Parametric equation of a circle.
// https://en.wikipedia.org/wiki/Parametric_equation#Circle
// 't' from -pi to pi.
vec2 pCircle(float r, float t)
{
    return vec2(r * sin(t), r * cos(t));
}

// Draw a circle.
vec3 circle(vec3 color, vec2 uv, float pos, float r, float blur)
{    
    vec3 res = white;
    
    // Change the bounds of 't' to draw a part of a circle.
    // (Not parameterized because it requires additional smoothing.)
    for (float t = 0.; t < 2. * pi; t += .01) {
        // Bounds.
        vec2 c1 = pCircle(pos,     t);
        vec2 c2 = pCircle(pos - r, t);
        
        // Find if a point belongs to a section using the triangle
        // inequality (comparing to 'eps' due to floating-point).
        float d1 = distance(c2, uv);
        float d2 = distance(uv, c1);
        float d3 = distance(c2, c1);
               
    	// Decreasing this value produces an interesting effect.
    	float eps = .001;
        
		if (abs(d1 + d2 - d3) < eps) {
            // XXX: This blurs inward, reducing the size of the circle.
            // XXX: When 'blur' == 1, the circle disappears.
            res = color;
            res *= smoothstep(d3, d3 * blur, d1);            
            res *= smoothstep(d3, d3 * blur, d2);
            break;
        }
        else res -= color;
    }
    
    return res;
}

// Draw a point.
vec3 point(vec3 color, vec2 uv, float pos, float r, float t, float blur)
{  
	// Bounds.
    vec2 c1 = pCircle(pos,     t);
    vec2 c2 = pCircle(pos - r, t);

    // Multiplying one of the arguments by -1 shifts it by pi.
    float d1 = distance(uv, c1);
    float d2 = distance(c1, c2);
    
    // XXX: Do not invert colors when 'blur' == 1.
    vec3 res = vec3(smoothstep(d2, d2 * blur, d1));
    
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
    
    color += red;   
    color -= circle(red - blue, uv, .5, .1, .9);
    
    // Without a loop, the parametric equation gives a point
    // on a circle, which can be used to create a rotating point.
	//
	// Multiplying 't' by -1 makes it move counterclockwise.
	// Multiplying 'iTime' changes the rotation speed.
    
    // float t = pi;  // fixed position
    float speed = 1.;
    float t = mod(iTime * speed, 2. * pi);  // rotate
    color -= point(red + blue - green, uv, .45, .01, t, .9);
    
    // Output to screen.
    fragColor = vec4(color, 1.);
}
