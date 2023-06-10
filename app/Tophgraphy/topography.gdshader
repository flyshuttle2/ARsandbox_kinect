shader_type spatial;

uniform sampler2D heightmap;
//albido贴图
uniform sampler2D _a;

uniform float height_ratio ;

void fragment() {
	// 将地形网格顶点的高度值修改为高度图中保存的值

	ALBEDO = texture(_a, UV*10.0).rgb;
	
}
void vertex() {
	VERTEX.y += texture(heightmap, UV).r * height_ratio;
	
}
