const float PI = 3.1415926535;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
  vec2 uv = texture_coords - 0.5;
  float z = sqrt(1.0 - uv.x * uv.x - uv.y * uv.y);
  float a = 1.0 / (z * tan(2 * 0.5));
  return texture2D(texture, (uv* a) + 0.5) * color;
}
