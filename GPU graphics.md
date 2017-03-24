# Shader着色器
Shader出现在OpenGL ES 2.0中，允许创建自己的Shader。必须同时创建两个Shader，分别是Vertex shader和Fragment shader.

# Shader工具
Shader会有很多坑，不过一些工具能够帮助你跳过这些坑
* GPUImage：<https://github.com/BradLarson/GPUImage>
* ShaderToy：<https://www.shadertoy.com/>
* Shaderific：<http://www.shaderific.com/>
* Quartz Composer：官方工具

# Shader使用范例

## Vertex shader
```objective-c
attribute vec4 position;
attribute vec4 inputTextureCoordinate；
varying vec2 textureCoordinate;
void main()
{
     gl_position = position;
     textureCoordinate = inputTextureCoordinate.xy;
}
```

## Fragment shader
直通滤镜
```objective-c
varying highp vec2 textureCoordinate; //highp属性负责变量精度，这个被加入可以提高效率
uniform sampler2D inputImageTexture; //接收一个图片的引用，当做2D的纹理，这个数据类型就是smpler2D。
void main()
{
     gl_FragColor = texture2D(inputImageTexture, textureCoordinate); //texture是GLSL（着色语言）特有的方法
}
```

# GLSL着色语言

## GLSL的官方快速入门指导
* OpenGL ES：<https://www.khronos.org/opengles/sdk/docs/reference_cards/OpenGL-ES-2_0-Reference-card.pdf>
* OpenGL：<https://www.khronos.org/files/opengl-quick-reference-card.pdf>

## 变量赋值
三个可以赋值给我们的变量的标签
* Uniforms：在渲染循环里作为不变的输入值
* Attributes：随顶点位置不同会变的输入值
* Varyings：用来在Vertex shader和Fragment shader之间传递信息的，比如在Vertex shader中写入varying值，然后就可以在Fragment shader中读取和处理

## 向量
有很多种向量，但是有三种会经常看到
* vec2：两个浮点数，适合在Fragment shader中保存X和Y坐标的情况
* vec3：三个浮点数
* vec4：四个浮点数，在图像处理中持续追踪每个像素的R,G,V,A这四个值。

## 矩阵
是浮点数组的数组。三个经常处理的矩阵对象
* mat2：相当于保存了两个vec2对象的值或四个浮点数。
* mat3
* mat4

## 向量和矩阵运算
线性代数发挥作用的地方。想知道线性代数如何工作可以看这个资源站：<http://betterexplained.com/articles/linear-algebra-guide/>

线性代数可以一次在很多值上进行并行操作，so，正好适合需求，GLSL内建了很多函数可以处理庞大的计算转换

## GLSL特有函数
GLSL内建的函数可以在Shaderific网站上找到：<http://www.shaderific.com/glsl-functions>。很多C语言数学库基本数学运算都有对应的函数。
* step()：GPU处理条件逻辑不是很好。step()允许在不产生分支的前提下实现条件逻辑。传入step()函数的值小于阈值就返回0.0，大于等于阈值就返回1.0。
* mix()：将两个颜色值混合为一个。
* clamp()：可以确保值在一个区间内。

## 复杂的Shader的例子
一个饱和度调节的Fragment shader的例子，出自《图形着色器：理论和实践》这本书。
```swift
varying highp vec2 textureCoordinate; //

uniform sampler2D inputImageTexture;
uniform lowp float saturation;

const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721); //光亮度里三个值相加要为1，各个值代表着颜色的百分比，中间是绿色的值，70%的比重会让效果更好点。

void main()
{
     lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate); //根据坐标取样图片颜色信息
     lowp float luminance = dot(textureColor.rgb, luminanceWeighting); //GLSL中的点乘运算，线性代数的点运算符相乘两个数字。点乘计算需要将纹理颜色信息和相对应的亮度权重相乘。然后取出所有的三个值相加到一起计算得到这个像素的中和亮度值。
     lowp vec3 greyScaleColor = vec3(luminance); //创建一个三个值都是亮度信息的vec3，如果只指定一个值，编译器会将其它的都设置成这个值
     gl_FragColor = vec4(mix(greyScaleColor, textureColor.rgb, saturation), textureColor.w); //用mix函数把计算的灰度值，初识的纹理颜色和得到的饱和度信息结合起来。
}
```

## 球形滤镜示例
```swift
varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;

uniform highp vec2 center;
uniform highp float radius;
uniform highp float aspectRatio;
uniform highp float refractiveIndex;

void main()
{
     highp vec2 textureCoordinateToUse = vec2(textureCoordinate.x, (textureCoordinate.y * aspectRatio + 0.5 - 0.5 * aspectRatio)); //归一化坐标空间需要考虑屏幕是一个单位宽和一个单位长。
     highp float distanceFromCenter = distance(center, textureCoordinateToUse); //计算特定像素点距离球形的中心有多远。使用GLSL内建的distance()函数，用勾股定律计算出中心坐标和长宽比矫正过的纹理坐标的距离
     lowp float checkForPresenceWithinSphere = step(distanceFromCenter, radius); //计算片段是否在球体内。

     distanceFromCenter = distanceFromCenter / radius;  //标准化到球心的距离，重新设置distanceFromCenter

     highp float normalizedDepth = radius * sqrt(1.0 - distanceFromCenter * distanceFromCenter); //模拟一个玻璃球，需要计算球的“深度”是多少。
     highp vec3 sphereNormal = normalize(vec3(textureCoordinateToUse - center, normalizedDepth)); //归一化

     highp vec3 refractedVector = refract(vec3(0.0, 0.0, -1.0), sphereNormal, refractiveIndex); //GLSL的refract()函数以刚才创建的球法线和折射率来计算当光线通过球时从任意一个点看起来如何。

     gl_FragColor = texture2D(inputImageTexture, (refractedVector.xy + 1.0) * 0.5) * checkForPresenceWithinSphere; //最后凑齐所有计算需要的颜色信息。
}
```

## 调试Shader
使用gl_FragColor调试代码。GPUImage是个开源的资源有些很酷的shader，非常好的学习shader的方式，可以拿一个你觉得很有意思的shader对着源码一点点看下去。GPUImage还有一个shader设计器<https://github.com/BradLarson/GPUImage/tree/master/examples/Mac/ShaderDesigner> 的Mac应用，可以测试shader而不用准备OpenGL代码。

## 性能调优
简单的方法达到调优目的，可以用下载Imagination Technologies PowerVR SDK<http://community.imgtec.com/developers/powervr/>这个工具帮助分析shader
* 消除条件逻辑：使用step()这样的函数
* 减少依赖纹理的读取：如果希望从附近像素取样而不是计算Fragment shader相邻像素的偏差，最好在Vertex shader中计算然后把结果以varying的方式传入Fragment shader里。
* 计算尽量简单：能够得到一个近似值就尽量用，不要用类似sin()，cos()，tan()的比较消耗的操作。
* 尽可能的将计算放到Vertex上：如果计算在图片上会有相同的结果或线性变化最好这样做。因为Vertex shader对每个顶点运行一次，而Fragment shader会在每个像素上运行一次。
* 移动设备使用合适的精度：在向量上使用低精度的值会变得更快。两个lowp vec4相加可以在一个时钟周期内完成，两个highp vec4相加则需要四个时钟周期。

# 边界探测
基于OpenCV库，不过这些步骤在GPUImage中都有完整的实现

## Sobel边界探测
这种操作在滤镜方面比机器视觉方面多。Sobel边界探测用于探测边界的出现位置，边界是由明变暗或者由暗变明的区域。在被处理的图片中一个像素的亮度反映了这个像素周围边界的强度。
* 第一步，将彩色图片弄成灰阶图，这个过程就是将每个像素的红绿蓝部分合一代表亮度的值。如是果YUV而不是RGB格式的可以省略这步，因为YUV是将亮度信息和色度信息分开的。如果简化到只剩亮度的话一个像素周围的边界强度就可以由周围3*3个临近像素计算得到。这个计算涉及Convolution Matrix（卷积矩阵），每个像素都要与这个矩阵计算出一个数值，因为没有顺序要求所以可以采取并行运算。
* Sobel的水平处理矩阵

-1 0 +1
-2 0 +2
-1 0 +1

* Sobel的垂直矩阵

-1 -2 -1
0 0 0
+1 +2 +1

* 和Sobel类似的变体，Prewitt边界探测。这个变体会在横向竖向矩阵中用不同的矩阵，但是运作过程差不多。
* OpenGL ES代码
```swift

precision mediump float;

//varying的都是在Vertex shader上定义了
varying vec2 textureCoordinate;
varying vec2 leftTextureCoordinate;
varying vec2 rightTextureCoordinate;

varying vec2 topTextureCoordinate;
varying vec2 topLeftTextureCoordinate;
varying vec2 topRightTextureCoordinate;

varying vec2 bottomTextureCoordinate;
varying vec2 bottomLeftTextureCoordinate;
varying vec2 bottomRightTextureCoordinate;

uniform sampler2D inputImageTexture;

void main()
{
     float bottomLeftIntensity = texture2D(inputImageTexture, bottomLeftTextureCoordinate).r;
     float topRightIntensity = texture2D(inputImageTexture, topRightTextureCoordinate).r;
     float topLeftIntensity = texture2D(inputImageTexture, topLeftTextureCoordinate).r;
     float bottomRightIntensity = texture2D(inputImageTexture, bottomRightTextureCoordinate).r;
     float leftIntensity = texture2D(inputImageTexture, leftTextureCoordinate).r;
     float rightIntensity = texture2D(inputImageTexture, rightTextureCoordinate).r;
     float bottomIntensity = texture2D(inputImageTexture, bottomTextureCoordinate).r;
     float topIntensity = texture2D(inputImageTexture, topTextureCoordinate).r;

     float h = -bottomLeftIntensity - 2.0 * leftIntensity - topLeftIntensity + bottomRightIntensity + 2.0 * rightIntensity + topRightIntensity;
     float v = -topLeftIntensity - 2.0 * topIntensity - topRightIntensity + bottomLeftIntensity + 2.0 * bottomIntensity + bottomRightIntensity;
     float mag = length(vec2(h, v)); //length()函数计算出水平和垂直矩阵转化后值的平方和的平方根的值，这个值会被拷贝进输出像素的红绿蓝通道中，这样就可以来代表边界的明显程度了。

     gl_FragColor = vec4(vec3(mag), 1.0);
}
```

## Canny边界探测
Canny探测会比Sobel复杂些，这样做会得到一条物体边界的干净线条。

探测过程：
* 先用Sobel矩阵得到边界梯度的强度。这个和Sobel比就是最后一个计算有些不同
```swift
vec2 gradientDirection;
gradientDirection.x = -bottomLeftIntensity - 2.0 * leftIntensity - topLeftIntensity + bottomRightIntensity + 2.0 * rightIntensity + topRightIntensity;
gradientDirection.y = -topLeftIntensity - 2.0 * topIntensity - topRightIntensity + bottomLeftIntensity + 2.0 * bottomIntensity + bottomRightIntensity;

float gradientMagnitude = length(gradientDirection);
vec2 normalizedDirection = normalize(gradientDirection);
normalizedDirection = sign(normalizedDirection) * floor(abs(normalizedDirection) + 0.617316); // Offset by 1-sin(pi/8) to set to 0 if near axis, 1 if away
normalizedDirection = (normalizedDirection + 1.0) * 0.5; // Place -1.0 - 1.0 within 0 - 1.0

gl_FragColor = vec4(gradientMagnitude, normalizedDirection.x, normalizedDirection.y, 1.0);
```
* 着色器步骤
```swift
precision mediump float;

varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform highp float texelWidth; //要处理的图片中临近像素之间的距离。
uniform highp float texelHeight; //同上
uniform mediump float upperThreshold; //预期边界强度上下限
uniform mediump float lowerThreshold; 

void main()
{
     vec3 currentGradientAndDirection = texture2D(inputImageTexture, textureCoordinate).rgb;
     vec2 gradientDirection = ((currentGradientAndDirection.gb * 2.0) - 1.0) * vec2(texelWidth, texelHeight);

     float firstSampledGradientMagnitude = texture2D(inputImageTexture, textureCoordinate + gradientDirection).r;
     float secondSampledGradientMagnitude = texture2D(inputImageTexture, textureCoordinate - gradientDirection).r;

     float multiplier = step(firstSampledGradientMagnitude, currentGradientAndDirection.r);
     multiplier = multiplier * step(secondSampledGradientMagnitude, currentGradientAndDirection.r);

     float thresholdCompliance = smoothstep(lowerThreshold, upperThreshold, currentGradientAndDirection.r);
     multiplier = multiplier * thresholdCompliance;

     gl_FragColor = vec4(multiplier, multiplier, multiplier, 1.0);
}
```

## Harris边角探测
多步骤的方法来探测场景中的边角。
* 先弄得只有亮度信息，再通过Sobel矩阵，普里维特矩阵或者其它相关的矩阵计算出一个像素X和Y方向的梯度值，计算的结果会将X梯度传入红色部分，Y梯度传入绿色部分，X与Y梯度的乘积传入蓝色部分。
* 对计算的结果进行高斯模糊。将模糊后图中取出红绿蓝编码的值带到计算边角点可能性公式：

R = Ix2 × Iy2 − Ixy × Ixy − k × (Ix2 + Iy2)2


#资料

## 相关数学
* 3D Math Primer for Graphics and Game Development <http://www.amazon.com/Math-Primer-Graphics-Game-Development/dp/1568817231/ref=sr_1_1?ie=UTF8&qid=1422837187&sr=8-1&keywords=3d+math+primer+for+graphics+and+game+development>
* The Nature of Code <http://natureofcode.com/>
* The Computational Beauty of Nature <http://www.amazon.com/Computational-Beauty-Nature-Explorations-Adaptation/dp/0262561271/ref=sr_1_1?s=books&ie=UTF8&qid=1422837256&sr=1-1&keywords=computational+beauty+of+nature>

## 相关GLSL
* Graphic Shaders: Theory and Practice <http://www.amazon.com/Graphics-Shaders-Theory-Practice-Second/dp/1568814348/ref=sr_1_1?s=books&ie=UTF8&qid=1422837351&sr=1-1&keywords=graphics+shaders+theory+and+practice>
* The OpenGL Shading Language <http://www.amazon.com/OpenGL-Shading-Language-Randi-Rost/dp/0321637631/ref=sr_1_1?s=books&ie=UTF8&qid=1422896457&sr=1-1&keywords=opengl+shading+language>
* OpenGL 4 Shading Language Cookbook <http://www.amazon.com/OpenGL-Shading-Language-Cookbook-Second/dp/1782167021/ref=sr_1_2?s=books&ie=UTF8&qid=1422896457&sr=1-2&keywords=opengl+shading+language>
* GPU Gems <http://http.developer.nvidia.com/GPUGems/gpugems_part01.html>
* GPU Pro: Advanced Rendering Techniques <http://www.amazon.com/GPU-Pro-Advanced-Rendering-Techniques/dp/1568814720/ref=sr_1_4?s=books&ie=UTF8&qid=1422837427&sr=1-4&keywords=gpu+pro>



