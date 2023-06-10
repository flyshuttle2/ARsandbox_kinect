shader_type spatial;
//shader_type canvas_item;
uniform sampler2D texture_albedo ;
uniform sampler2D ColorMapSampler;
uniform sampler2D pixelCornerElevationSampler;


//
varying vec3 color;

uniform vec3 albedo : source_color;

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
	vec2 base_uv = UV;
	//vec4 albedo_tex = texture(texture_albedo,base_uv);
	float depth = texture(texture_albedo,base_uv).r;
	//VERTEX.z = depth;
	//VERTEX.z = 0.4;
	//对应在色卡上的颜色
	vec4 tempVec4=texture(ColorMapSampler,vec2(depth,0.5));
	//vec4 tempVec4=texture(ColorMapSampler,vec2(depth,0.5));
	//vec4 tempVec4=vec4(0.4,0.8, 0.9, 1.0);
	//vec3 colorDic = vec3(tempVec4.x+0.6,tempVec4.y+0.3, tempVec4.z+0.3);
	//vec3 colorDic = vec3(depth,depth, depth);
	//vec3 colorDic = vec3(0.4,0.8, 0.9);
	
    //COLOR = tempVec4;
     //ALBEDO = colorDic;
	 //ALBEDO = vec3(depth,depth, depth);
	
	
	float step = depth / 0.15;   
	float f  = fract(step);

	float aa = smoothstep(0.0051, 0.03, f); 
	//如果偏移小，aa为0，画等高线；如果偏移大，aa为1，不画等高线。

	if (aa < 1.0)
		{
	tempVec4=vec4(0.1+aa/5.0, 0.1+aa/5.0 ,0.1+aa/5.0 ,1.0); 
	}         		
	
	
	
	
	
	
	
	
	
	
	
	
	ALBEDO =  vec3(tempVec4.x,tempVec4.y, tempVec4.z);
	
	
	
	
	
	//ALBEDO = albedo.rgb * albedo_tex.rgb;

	
	
	
	
	
	
	
	
	
	
	
	
}