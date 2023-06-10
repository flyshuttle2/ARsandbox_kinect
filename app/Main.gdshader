shader_type spatial;
//shader_type canvas_item;
uniform sampler2D texture_albedo;
uniform sampler2D ColorMapSampler;

varying vec3 color;

uniform vec3 albedo : source_color;
uniform sampler2D noise;
uniform float noise_scale = 10.0;
uniform float height_scale;

varying float height;
varying vec3 world_pos;

void vertex() {
	
//	float depth = texture(texture_albedo, UV).r;
//
//	vec4 tempVec4=texture(ColorMapSampler,vec2(depth,0.5));
//
//	vec3 colorDic = vec3(tempVec4.x,tempVec4.y, tempVec4.z);
//
//	color = colorDic;
	

}

void fragment() {
	float depth = texture(texture_albedo, UV).r;
	//VERTEX.z = depth;
	//VERTEX.z = 0.4;
	//对应在色卡上的颜色
	//vec4 tempVec4=texture(ColorMapSampler,vec2(depth,0.5));
	vec4 tempVec4=texture(ColorMapSampler,vec2(depth,0.5));
	//vec4 tempVec4=vec4(0.4,0.8, 0.9, 1.0);
	//vec3 colorDic = vec3(tempVec4.x+0.6,tempVec4.y+0.3, tempVec4.z+0.3);
	vec3 colorDic = vec3(depth,depth, depth);
	//vec3 colorDic = vec3(0.4,0.8, 0.9);
	
    //COLOR = tempVec4;
     ALBEDO = colorDic;
}