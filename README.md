# GifLib
The class for creating GIFs on Roblox.

![](https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/4X/e/6/1/e6176fbbced47d0006083c05cc3c16e09cd34b69.gif)

## Constructor
| Name | Description |
| ----------- | ----------- |
| ```Gif.new(instance, id)``` | Constructs a GIF on Roblox based on the instance passed. |

## Properties
| Name | Type | Description |
| ----------- | ----------- | ----------- |
| ```instance``` | Instance | An image label, image button, decal, or texture. |
| ```id``` | Table | A list of image IDs to cycle through. |
| ```enabled``` | Boolean | A debounce. |
| ```rows``` | Number | The number of rows in the spritesheet. |
| ```columns``` | Number | The number of columns in the spritesheet. |
| ```frames``` | Number | The number of frames or images to cycle through. |
| ```start``` | Number | The first frame to start at. |
| ```direction``` | String | The direction of the spritesheet animation; "horizontal" or "vertical". |
| ```rate``` | Number | The speed of the animation; wait time between each frame. |
| ```width``` | Number | The width of the spritesheet. |
| ```height``` | Number | The height of the spritesheet. |
| ```maxLoops``` | Number | The maximum number of loops to play. |

## Functions
| Name | Description |
| ----------- | ----------- |
| ```Play``` | Plays the GIF animation. |
| ```Stop``` | Stops the GIF animation. |
| ```Destroy``` | Destructs a GIF object. |
