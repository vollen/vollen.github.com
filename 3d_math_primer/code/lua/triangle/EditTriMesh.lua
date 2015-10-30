--材质
local material = {}
    material.diffuseTexureName = {}
    material.mark   = 0

--优化选项
local optimationParameters = {}
    --判断顶点融合的容差
    optimationParameters.coincidentVertexTolerance  = 0
    --如果同一边被两个三角形公用,那么当这两个三角形夹角cos小于这个值时,该边上的顶点不能被焊接
    optimationParameters.cosOfEdgeAngleTolerance    = 0

--顶点
local vertex = {}
    --3d坐标
    vertex.p        = vec3.new()
    --法向量
    vertex.normal   = vec3.new()
    vertex.u        = 0
    vertex.v        = 0
    vertex.mark     =0

--三角形的顶点(用索引指向实际的顶点)
local ver = {}
    ver.index   = 0
    ver.u       = 0
    ver.v       = 0

--三角形
local tri = {}
    tri.vList   = {{}, {}, {}}
    tri.normal  = vec3.new()
    tri.part    = 0
    tri.material = 0
    tri.mark    = 0
    tri.isDegenerate = function ()
    end
    tri.findVer = function (index)
    end


--三角形网格
local mesh = {}
EditTriMsh = mesh

    --复制
    mesh.setBy = function (src)
    end

    mesh.vertexCount = function ()
        return _vCount
    end

    mesh.triCount = function ()
        return _tCount
    end

    mesh.materialCount = function ()
        return _mCount
    end

    mesh.getVertex = function(index)
    end

    mesh.getTri = function (index)
    end

    mesh.getMaterial = function (index)
    end

    mesh.empty  = function()
    end

    mesh.setVertexCount = function (count)
        _vCount = count
    end

    mesh.setTriCount = function (count)
        _tCount = count
    end

    mesh.setMaterialCount = function (count)
        _mCount = count
    end


