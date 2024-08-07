# 基础光照

## emissive 自发光

> 自发光不会形成光源

详见 assets/material/note2

### 获取当前材质的法线，并进行归一化

```shader
// 逐顶点渲染直接获取
normalize(v.normal)
// 逐像素渲染，需要在顶点渲染中转换法线
// vert 函数中
o.normal = mul((float3x3)unity_ObjectToWorld, v.normal);
...
// frag 函数中
normal = normalize(i.normal);
```

### 获取世界空间下的光源 并归一化

```shader
 float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
```

### 计算光源与法线的夹角，dot为点积，即计算两个向量的cos，并和0比较，因为小于0是没有意义的

```shader
float NdotL = max(0, dot(lightDir, normal));
```

### 计算光照强度

```shader
 float3 diffuse = NdotL * _LightColor0.rgb;
```

### 计算光照颜色

```shader
float3 emissive = _Emission.rgb;
```

1. 最终颜色

```shader
o.color = emission + diffuse;
```

## specular 高光反射

详见 assets/material/note2

### 逻辑同自发光，由自发光部分的代码改为高光

```shader
   float spec = pow(max(0, dot(i.normal, halfDir)), _Shininess * 128);
```

## ambient 自然光

详见 assets/material/note2

## diffuse 漫反射

详见 assets/material/note2

### 逻辑同自发光，去掉自发光部分

## 逐像素还是逐顶点

在哪里计算这些光照模型呢？通常来讲，我们有两种选择：在片元着色器中计算，也被称为逐像素光照(per-pixel lighting):在顶点着色器中计算，也被称为逐顶点光照(per-vertex lighting)。

### 逐像素 Phong

在逐像素光照中，我们会以每个像素为基础，得到它的法线（可以是对顶点法线插值得到的，也可以是从法线纹理中采样得到的），然后进行光照模型的计算。这种在面片之间对顶点法线进行插值的技术被称为 **Phong** 着色(Phong shading),也被称为**Phong插值或法线插值着色技术**。这不同于Phong光照模型。

### 逐顶点 高洛德着色(Gouraud shading)

与之相对的是逐顶点光照，也被称为**高洛德着色(Gouraud shading)**。在逐顶点光照中，我们在每个顶点上计算光照，然后会在渲染图元内部进行线性插值，最后输出成像素颜色。由于顶点数目往往远小于像素数目，因此逐顶点光照的计算量往往要小于逐像素光照。但是，由于逐顶点光照依赖于线性插值来得到像素光照，因此，当光照模型中有非线性的计算（例如计算高光反射时）时，逐顶点光照就会出问题。在后面的章节中，我们将会看到这种情况。而且，由于逐顶点光照会在渲染图元内部对顶点颜色进行插值，这会导致渲染图元内部的颜色总是暗于顶点处的最高颜色值，这在某些情况下会产生明显的棱角现象。

## 兰伯特与半兰伯特 (漫反射相关)

即便使用了逐像素漫反射光照，有一个问题仍然存在。在光照无法到达的区域，模型的外观通常是全黑的，没有任何明暗变化，这会使模型的背光区域看起来就像一个平面一样，失去了模型细节表现。实际上我们可以通过添加环境光来得到非全黑的效果，但即便这样仍然无法解决背光面明暗一样的缺点。为此，有一种改善技术被提出来，这就是半兰伯特(Half Lambert)光照模型。

## bLinn-Phong (高光反射相关)

Blinn-Phong光照模型的高光反射部分看起来更大、更亮一些。在实际渲染中，绝大多数情况我们都会选择Blinn-Phong光照模型。需要再次提醒的是，这两种光照模型都是经验模型，也就是说，我们不应该认为Blinn-Phong模型是对“正确的”Phong模型的近似。实际上Blinn-Phong模型更符合实验结果。
