uniform lowp float speed;

/////////////////////////////////////////////////////////
// iridiscent

//The current foreground texture co-ordinate
varying mediump vec2 vTex;
//The foreground texture sampler, to be sampled at vTex
uniform lowp sampler2D samplerFront;
//The current foreground rectangle being rendered
uniform mediump vec2 srcStart;
uniform mediump vec2 srcEnd;
//The current foreground source rectangle being rendered
uniform mediump vec2 srcOriginStart;
uniform mediump vec2 srcOriginEnd;
//The current foreground source rectangle being rendered, in layout 
uniform mediump vec2 layoutStart;
uniform mediump vec2 layoutEnd;
//The background texture sampler used for background - blending effects
uniform lowp sampler2D samplerBack;
//The current background rectangle being rendered to, in texture co-ordinates, for background-blending effects
uniform mediump vec2 destStart;
uniform mediump vec2 destEnd;
//The time in seconds since the runtime started. This can be used for animated effects
uniform mediump float seconds;
//The size of a texel in the foreground texture in texture co-ordinates
uniform mediump vec2 pixelSize;
//The current layer scale as a factor (i.e. 1 is unscaled)
uniform mediump float layerScale;
//The current layer angle in radians.
uniform mediump float layerAngle;


// CC0 licensed, do what thou wilt.
const lowp float SEED = 42.0;


lowp float rayspeed = 0.2;
lowp float swayRandomized(lowp float seed, lowp float value)
{
    lowp float f = floor(value);
    lowp float start = sin((cos(f * seed) + sin(f * 1024.)) * 345. + seed);
    lowp float end   = sin((cos((f+1.) * seed) + sin((f+1.) * 1024.)) * 345. + seed);
    return mix(start, end, smoothstep(0., 1., value - f));
}

lowp float cosmic(lowp float seed, lowp vec3 con)
{
    lowp float sum = swayRandomized(seed, con.z + con.x);
    sum = sum + swayRandomized(seed, con.x + con.y + sum);
    sum = sum + swayRandomized(seed, con.y + con.z + sum);
    return sum * 0.3333333333 + 0.5;
}

void main(void)
{
    // Normalized pixel coordinates (from 0 to 1)
    
    // aTime, s, and c could be uniforms in some engines.
    lowp float aTime = seconds * rayspeed;
    lowp vec3 s = vec3(swayRandomized(-16405.31527, aTime - 1.11),
                  swayRandomized(-77664.8142, aTime + 1.41),
                  swayRandomized(-50993.5190, aTime + 2.61)) * 3.;
    lowp vec3 c = vec3(swayRandomized(-10527.92407, aTime - 1.11),
                  swayRandomized(-61557.6687, aTime + 1.41),
                  swayRandomized(-43527.8990, aTime + 2.61)) * 3.;
    lowp vec3 con = vec3(0.0004375, 0.0005625, 0.0008125) * aTime + c * vTex.x + s * vTex.y;
    con.x = cosmic(SEED, con);
    con.y = cosmic(SEED, con);
    con.z = cosmic(SEED, con);
    
    gl_FragColor = vec4(sin(con * 3.14159265) * 0.5 + 0.5,1.0);
}
