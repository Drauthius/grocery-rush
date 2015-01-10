return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 12,
  height = 12,
  tilewidth = 64,
  tileheight = 64,
  backgroundcolor = { 42, 0, 63 },
  properties = {},
  tilesets = {
    {
      name = "floor",
      firstgid = 1,
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "gfx/floor.png",
      imagewidth = 256,
      imageheight = 256,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Floor",
      x = 0,
      y = 0,
      width = 12,
      height = 12,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 16, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "Collision",
      x = 0,
      y = 0,
      width = 12,
      height = 12,
      visible = true,
      opacity = 1,
      properties = {
        ["collidable"] = "true"
      },
      encoding = "lua",
      data = {
        11, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 12,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        15, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 16
      }
    },
    {
      type = "objectgroup",
      name = "Shelves",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "salad",
          shape = "rectangle",
          x = 192,
          y = 448,
          width = 64,
          height = 256,
          rotation = -360,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "cereal",
          shape = "rectangle",
          x = 256,
          y = 286,
          width = 64,
          height = 192,
          rotation = 450,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "olive oil",
          shape = "rectangle",
          x = 450,
          y = 286,
          width = 64,
          height = 192,
          rotation = 450,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "bread",
          shape = "rectangle",
          x = 449,
          y = 544,
          width = 64,
          height = 128,
          rotation = 180,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "mustard",
          shape = "rectangle",
          x = 384,
          y = 611,
          width = 64,
          height = 128,
          rotation = 270,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "coffee",
          shape = "rectangle",
          x = 640,
          y = 64,
          width = 64,
          height = 192,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "carrots",
          shape = "rectangle",
          x = 640,
          y = 384,
          width = 64,
          height = 320,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "ketchup",
          shape = "rectangle",
          x = 513,
          y = 545,
          width = 64,
          height = 128,
          rotation = -180,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "potato chips",
          shape = "rectangle",
          x = 516,
          y = 351,
          width = 64,
          height = 192,
          rotation = 180,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "banana",
          shape = "rectangle",
          x = 256,
          y = 64,
          width = 64,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "Entry",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "leftDoor",
          shape = "rectangle",
          x = 64,
          y = 704,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 9,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "rightDoor",
          shape = "rectangle",
          x = 128,
          y = 704,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 10,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "Cashiers",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 193,
          y = 191,
          width = 64,
          height = 128,
          rotation = 450,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
