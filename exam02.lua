function newPuzzle(m,n,initialPuzzle)
	if (m*n)~=#initialPuzzle then return end

	local self={puzzle=initialPuzzle,sizeM=m,sizeN=n}

	local getNumbers=function ()
		puzzleCopy={}
		for i,v in ipairs(self.puzzle) do
			puzzleCopy[i]=v
		end
		return puzzleCopy
	end

    local getM=function ()
        local localM=self.sizeM;
        return localM
    end

    local getN=function ()
        local localN=self.sizeN;
        return localN
    end

	local moveNumber=function (position,direction)
		if self.puzzle[position] and self.puzzle[position]>0 then
			local x=math.floor((position-1 )%m)
			local y=math.floor((position-1 )/m)

			local moveSteps={{0,-1},{1,0},{0,1},{-1,0}}
			local newX=x+moveSteps[direction][1]
			local newY=y+moveSteps[direction][2]

			if newX>= 0 and newX<m and newY>=0 and newY<n then
				local newPos=newY*m+newX+1
				if self.puzzle[newPos]==0 then
					self.puzzle[newPos],self.puzzle[position] = self.puzzle[position],self.puzzle[newPos]
				end
			end
		end
	end

	return{
		getM=getM,
		getN=getN,
		getNumbers=getNumbers,
		moveNumber=moveNumber
	}
end

function p4_SlidePuzzle(p)
    local m=p.getM(); local n=p.getN(); local num=m*n
    local begin={}; begin=p.getNumbers()
    local path; path={}; local record; record={}
    local dirCode={[0]=3,[1]=1,[2]=4,[3]=2};  local rDirCode={[0]=1,[1]=3,[2]=2,[3]=4}; local maxDepth=0
    
    local dest="";
    for i=1,num-1,1 do dest=dest..i end
    dest=dest.."0"
    
    local dir={[0]={[0]=1,[1]=0},[1]={[0]=-1,[1]=0},[2]={[0]=0,[1]=-1},[3]={[0]=0,[1]=1}}
    local coef=1
        if num==8 then
            coef=1
        elseif num==16 and m==4 then
            coef=2.7
        elseif num==12 and (m==4 or m==3)   then
            coef=1.3
        elseif num==15 then
            coef=1
        elseif num==10 then
            coef=1
        elseif num==9 then
            coef=1.6
        elseif num==14 then
            coef=1
        elseif num==16 then
            coef=1
        elseif num==12 then
            coef=1
        end
    
    local _x; local _y;
    for i=1,num,1 do
        if begin[i]==0 then
            _x=math.floor((i-1)/m)+1
            _y=(i-1)%m+1
        end
    end
    local start={}; start["r"]=_x; start["c"]=_y; start.table=begin

    
    local copy=function(u)
        local v={}
        v.r=u.r; v.c=u.c
        v.table={}
        for i,j in ipairs(u.table) do
            v.table[i]=j
        end
        return v
    end
    
    local distance=function(table)
        local res=0; local tmp
        for i=1,n,1 do
            for j=1,m,1 do
                if table[(i-1)*m+j]>0 then
                   tmp=(i-1)*m+j
                   res=res+math.abs(math.floor((table[tmp]-1)/m)+1-i)+math.abs((table[tmp]-1)%m+1-j) 
                end
            end
        end
        return res
    end
    
    local hash=function(table)
        local sums=""
        for i=1,num,1 do
            sums=sums..table[i]
        end
        return sums
    end
   
    local dfs
    local step=0
    
    dfs=function(cur,depth,h,preDir)
        local judge=hash(cur.table)
        if judge==dest then
            return 0
        end
        
        --剪枝函数 当前深度+当前曼哈顿距离
        if (depth+h*coef)>maxDepth then
            return 1
        end
        
        local nxt;
        for i=0,3,1 do
            while true do
                if dirCode[i]==preDir then break end
                step=step+1
                nxt=copy(cur)
                
                --获取最新空位位置
                nxt.r=cur.r+dir[i][0]
                nxt.c=cur.c+dir[i][1]
                local pos1; pos1=(cur.r-1)*m+cur.c
            
                if nxt.r<1 or nxt.r>n or nxt.c<1 or nxt.c>m then break end
                local nxth=h; local preLen; local Len;
                local pos2; pos2=(nxt.r-1)*m+nxt.c;
                
                --求取新的distance
                local desNum=cur.table[pos2]; local desR=math.floor((desNum-1)/m)+1; local desC=(desNum-1)%m+1
                preLen=math.abs(nxt.r-desR)+math.abs(nxt.c-desC)
                Len=math.abs(cur.r-desR)+math.abs(cur.c-desC)
                nxth=h-preLen+Len
                
                --获取新状态的table
                nxt.table[pos2],nxt.table[pos1]=nxt.table[pos1],nxt.table[pos2]
                path[depth]=rDirCode[i]
                path[depth]=rDirCode[i]
                record[depth]=pos2
                if dfs(nxt,depth+1,nxth,rDirCode[i])==0 then
                    return 0
                end
                break
            end
        end
        return 1
    end
    
    local search=function()
        local nh=distance(begin)
        maxDepth=nh
        local cur=copy(start)
        while dfs(cur,1,nh,0)==1 do maxDepth=maxDepth+1;cur=copy(start) end
        return maxDepth
    end
    
    local count=search()
    print(""..count.." "..step)
    
    for i,j in ipairs(path) do
        p.moveNumber(record[i],j)
    end
    
end

function testSample(m,n,t)
	p1=newPuzzle(m,n,t)
	p4_SlidePuzzle(p1)
	local resStr="";
	local finalT=p1.getNumbers()
	for i,v in ipairs(finalT) do
		resStr=resStr .. v
	end
	return resStr
end

print(testSample(3,3,{1,2,3,4,8,0,5,7,6})) --2
print(testSample(3,3,{8,7,6,5,4,3,2,1,0})) --5

print(testSample(3,3,{2,0,8,7,5,3,1,4,6}))
print(testSample(3,3,{5,8,1,2,7,3,6,4,0}))
print(testSample(3,3,{5,8,7,6,4,0,1,2,3}))
print(testSample(3,3,{0,2,6,1,5,4,7,8,3}))
print(testSample(3,3,{3,6,4,5,1,2,7,8,0}))
print(testSample(3,3,{4,6,8,3,0,7,5,2,1}))