# asset modal

## 入门

资源在 assets/fbx,例如 ResialinStout ,拖动 ReisalinStout-WhiteTShirt 到场景

1. 创建材质  (Assets/material/node1)
2. 材质改为贴图 Unlit/Texture
3. 拖动贴图 T00 png 到 material Unlit/Texture select
4. 拖动 material to note1 ReisalinStout-WhiteTShirt BodySkin material element0

重复上述操作

## 贴图类型

以 ResialinStout的第一套为例

1. T000 衣着基础贴图
2. T00A AO贴图（偏向于影响光照贴图）
3. T00C 头发基础贴图
4. T00F 头发mask贴图 高光用的
5. T001 是法线贴图
6. T002 AO贴图（偏向于影响光照贴图）
7. T003 是mask贴图 RG通道无用 B为高光的遮罩 A通道为粗糙度 总体控制高光
8. T004 眼睛贴图
9. T005 眼睛AO贴图
10. T006 眼睛法线贴图
11. T008 面部基础贴图
