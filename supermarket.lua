return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 10,
  height = 10,
  tilewidth = 64,
  tileheight = 64,
  backgroundcolor = { 34, 17, 52 },
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
      tiles = {
        {
          id = 1,
          properties = {
            ["collidable"] = "true"
          }
        },
        {
          id = 2,
          properties = {
            ["collidable"] = "true"
          }
        },
        {
          id = 5,
          properties = {
            ["collidable"] = "true"
          }
        },
        {
          id = 6,
          properties = {
            ["collidable"] = "true"
          }
        },
        {
          id = 10,
          properties = {
            ["collidable"] = "true"
          }
        },
        {
          id = 11,
          properties = {
            ["collidable"] = "true"
          }
        },
        {
          id = 14,
          properties = {
            ["collidable"] = "true"
          }
        },
        {
          id = 15,
          properties = {
            ["collidable"] = "true"
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Floor",
      x = 0,
      y = 0,
      width = 10,
      height = 10,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 1, 1, 1, 1, 1, 1, 1, 1, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "Collision",
      x = 0,
      y = 0,
      width = 10,
      height = 10,
      visible = true,
      opacity = 1,
      properties = {
        ["collidable"] = "false"
      },
      encoding = "lua",
      data = {
        11, 6, 6, 6, 6, 6, 6, 6, 6, 12,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 16,
        2, 0, 0, 0, 0, 0, 0, 0, 0, 12,
        15, 0, 15, 3, 3, 3, 10, 3, 3, 16
      }
    },
    {
      type = "objectgroup",
      name = "Collision",
      visible = false,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 384,
          y = 576,
          width = 64,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {
            ["collidable"] = "true"
          }
        }
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
          type = "ketchup",
          shape = "rectangle",
          x = 192,
          y = 192,
          width = 64,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "chips",
          shape = "rectangle",
          x = 256,
          y = 576,
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
          x = 192,
          y = 320,
          width = 64,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "coffee",
          shape = "rectangle",
          x = 63,
          y = 128,
          width = 64,
          height = 64,
          rotation = 270,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "cornflakes",
          shape = "rectangle",
          x = 512,
          y = 64,
          width = 64,
          height = 192,
          rotation = 90,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "olive oil",
          shape = "rectangle",
          x = 576,
          y = 320,
          width = 64,
          height = 128,
          rotation = 180,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "olive oil",
          shape = "rectangle",
          x = 576,
          y = 448,
          width = 64,
          height = 128,
          rotation = 180,
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
          y = 576,
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
          y = 576,
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
          x = 448,
          y = 448,
          width = 64,
          height = 128,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
