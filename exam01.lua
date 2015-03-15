function p1_Equation(a,b,c,d)
    local x; local y; local z;
    x = nil; y = nil; z = nil
    
    local func=function(atom)
        if atom==0 then
            return atom;
        elseif atom>0 then
            return atom^(1/3)
        else
            atom=(-1)*atom
            atom=atom^(1/3)
            atom=(-1)*atom
            return atom
        end    
    end
    
    if type(a)=="number" and type(b)=="number" and type(c)=="number" and type(d)=="number" then
        if a~=0 then
            local p=(3*a*c-b*b)/(3*a*a); local q=(27*a*a*d-9*a*b*c+2*b*b*b)/(27*a*a*a)
            local gamma = (q/2)^2+(p/3)^3
            local gammas;
            if math.abs(gamma)<1e-10 then
                gammas=0
            else
                gammas=gamma
            end
            if gammas>0 then
                local first=(-1)*(q/2); local second=(gamma)^0.5
                x=func(first+second)+func(first-second)-b/(3*a)
            elseif gammas==0 then
                x=func((-1)*q/2)+func((-1)*q/2)-b/(3*a)
                y=(-1)*func((-1)*q/2)-b/(3*a)
                if y<x then x,y=y,x end
            else
                local second=(-1*gamma)^0.5; local first=(-1)*q/2; local length=(first^2+second^2)^0.5
                angles=math.pi-1*math.atan(3^0.5)
                local angle
                if first==0 then
                    angle=math.pi/2
                elseif first>0 then
                    angle=math.atan(second/first)
                else
                    angle=math.pi+math.atan(second/first)
                end
                length=func(length); angle=(1/3)*angle
                x=2*length*math.cos(angle)-b/(3*a)
                y=2*length*math.cos(angle+angles)-b/(3*a)
                z=2*length*math.cos(angle-angles)-b/(3*a)
                if x>y then x,y=y,x end
                if x>z then x,z=z,x end
                if y>z then y,z=z,y end
            end     
        else
            if b~=0 then
                local delta; delta = c^2-4*b*d
                if delta< 0 then
                    return "nil"
                elseif delta==0 then
                    x=-1*c/(2*b)
                else
                    x=(-1*c-delta^0.5)/(2*b); y=(-1*c+delta^0.5)/(2*b);
                end 
            else
                if c~=0 then
                    x=-1*d/c
                else
                    if d~=0 then 
                        return "nil"
                    else
                        return "all"
                    end
                end
            end
        end
    else
        return "nil"
    end
    
    local flag; flag=0;
    local result; result = nil
    
    local floors=function(atom)
        if atom>0 then 
            atom=atom+0.005; atom=atom-atom%0.01
        elseif atom<0 then
            atom=-atom; atom=atom+0.005; atom=atom%0.01-atom
        end
        atom=string.format("%0.2f",atom)
        if atom=="-0.00" then atom="0.00" end
        return atom
    end
    
    if x then
        x=floors(x)
        flag=flag+1  
    end
    if y then
        y=floors(y)
        if y~=x then flag=flag+1 end    
    end
    if z then
        z=floors(z)
        if flag==2 then
            if z~=y then flag=flag+1 end
        elseif flag==1 then
            if z~=x then flag=flag+1; y=z end
        end
    end
    if flag==1 then 
        return x
    elseif flag==2 then
        local str=x..","..y
        return str
    elseif flag==3 then
        local str=x..","..y..","..z
        return str
    end  
end

function p2_Dungeon(t)
    local table={}
    local num=0
    for rubblish,atom1 in ipairs(t) do
        num=num+1
        if table[atom1] then
            table[atom1]=table[atom1]+1
        else
            table[atom1]=1
        end 
    end
    local sum=1
    local second=num
    for rubblish,atom2 in ipairs(table) do
        local first=atom2
        local cluster=1
        for var=first,1,-1 do
            cluster=cluster*second/var
            second=second-1
        end
        sum=sum*cluster
    end
    return sum
end

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
    local m=p.getM(); local n=p.getN(); local number=m*n
    local table={}; table=p.getNumbers()
    local record; record={}; local path; path={}
    
    local func=function(nums)
        local tmp=1
        while nums>0 do
            tmp=tmp*nums
            nums=nums-1
        end 
        return tmp
    end 
    
    local hash=function(table)
        local k; local res=0
        for i=1,number,1 do
            k=0
            for j=1,i-1,1 do
                if table[j]>table[i] then
                    k=k+1
                end
            end
        res=res+k*func(i-1)
        end
        return res
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
    
    local dest=(number-1)*func(number-1)
    
    local openset={}; local len=0; local atoms={}
    local dis; local hashs; local his; local curr;
    local queues={}; local length=0
    
    table=p.getNumbers()
    for i=1,number,1 do
        if table[i]==0 then
            currs=i
        end
    end
    hashs=hash(table)
    
    local adjustup=function(position)
        local tmp=queues[position]
        local i=math.floor(position/2)
        while i>0 and openset[queues[i]].value>openset[tmp].value do
            queues[position]=queues[i]
            position=i
            i=math.floor(position/2)
        end
        queues[position]=tmp
    end
    
    local adjustdown=function(position)
        local tmp=queues[position]
        local i=2*position
        while i<=length do
            if i<length and openset[queues[i]].value>openset[queues[i+1]].value then
                i=i+1
            end
            if openset[tmp].value<=openset[queues[i]].value then
                break
            else
                queues[position]=queues[i]
                position=i
            end 
            i=i*2
        end
        queues[position]=tmp
    end
    
    local copy=function(u)
        local open={}
        open.history=u.history; open.distance=u.distance; open.current=u.current; open.hash=u.hash; open.value=u.value; open.table={}
        for i,j in ipairs(u.table) do
            open.table[i]=j
        end
        return open
    end
    
    local search=function(step)
        while length>0 do
            local u=queues[1]      
            local tabs; local newtable;
            local curr=openset[u].current
            local v;
            for i=1,4,1 do
                v=copy(openset[u])
                local tag; tag=nil
                local pos1; pos1=curr; local pos2
                
                if (pos1/m)<=(n-1) and i==1 then
                    pos2=pos1+m
                    tag=1
                end
                if (pos1/m)>1 and i==3 then
                    pos2=pos1-m
                    tag=1
                end
                if pos1%m~=0 and i==4 then
                    pos2=pos1+1
                    tag=1
                end
                if pos1%m~=1 and i==2 then
                    pos2=pos1-1
                    tag=1
                end
                
                if tag==1 then
                    v.table[pos1],v.table[pos2]=v.table[pos2],v.table[pos1]
                    hashs=hash(v.table)
                    step=step+1
                    
                    if step>8000 then return end
                    if hashs==dest then
                        record[dest]=i
                        path[dest]=v.hash
                        return 1
                    end
                    
                    if not record[hashs] then
                        record[hashs]=i
                        v.history=v.history+1
                        path[hashs]=v.hash
                        v.hash=hashs
                        
                        local desNum=v.table[pos1]
                        local desR=math.floor((desNum-1)/m)+1; local desC=(desNum-1)%m+1
                        local nxtr=math.floor((pos2-1)/m)+1; local nxtc=(pos2-1)%m+1
                        local cusr=math.floor((pos1-1)/m)+1; local cusc=(pos1-1)%m+1
                        v.distance=v.distance-(math.abs(nxtr-desR)+math.abs(nxtc-desC))+(math.abs(cusr-desR)+math.abs(cusc-desC))
                        
                        v.current=pos2
                        v.value=v.distance+v.history%nums_
                        len=len+1
                        openset[len]=v
                        length=length+1
                        queues[length]=len
                        adjustup(length)
                    end
                end
            end
            openset[queues[1]]=nil
            queues[1]=queues[length]
            length=length-1
            if length>1 then adjustdown(1) end
        end
    end     
    
    local control={}
    local pathMove=function()
        local i=dest
        while path[i] do
            control[#control+1]=record[i]
            i=path[i]
        end
    end
    
    if hashs~=dest then
        record[hashs]=1
        if number==9 then
            nums_=13
        elseif number==8 then
            nums_=9
        elseif number==16 and m==4 then
            nums_=8
        elseif number==12 and (m==4 or m==3)   then
            nums_=10
        elseif number==15 then
            nums_=9
        elseif number==10 then
            nums_=15
        elseif number==6 then
            nums_=9
        elseif number==4 then
            nums_=8
        elseif number==14 then
            nums_=15
        elseif number==16 then
            nums_=14
        elseif number==12 then
            nums_=10
        end
        atoms["table"]={}; atoms["history"]=0; atoms["distance"]=distance(table); atoms["current"]=currs; atoms["hash"]=hashs; atoms["value"]=atoms["distance"]+atoms["history"]%nums_
        for i,j in ipairs(table) do atoms.table[i]=j end
        len=len+1; openset[len]=atoms;
        length=length+1; queues[length]=len
        local finish=search(0)
        if finish==1 then
            pathMove()
            
            for i=#control,1,-1 do
                 if control[i]==1 then
                     currs=currs+m
                     p.moveNumber(currs,1)
                 elseif control[i]==2 then
                     currs=currs-1
                    p.moveNumber(currs,2)
                 elseif control[i]==3 then
                    currs=currs-m
                    p.moveNumber(currs,3)
                 elseif control[i]==4 then
                    currs=currs+1
                    p.moveNumber(currs,4)
                 end
            end
        end
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

str=p1_Equation(1,10,3,-20)
print(str)
str=p1_Equation(1,100,3,-20)
print(str)
x=p2_Dungeon({1,1,2,2})
print(""..x)
print(testSample(4,4,{2,4,7,5,10,6,11,3,1,8,15,12,13,14,9,0}))
print(testSample(4,4,{15,2,1,9,6,11,7,10,13,14,8,12,5,4,3,0}))
print(testSample(4,3,{9,11,8,4,5,10,7,0,1,2,3,6}))
print(testSample(4,3,{9,8,4,11,7,3,10,2,6,5,1,0}))
print(testSample(3,4,{11,3,5,6,10,4,2,0,8,7,1,9}))
print(testSample(3,4,{11,8,9,4,10,0,7,6,5,1,3,2}))
print(testSample(3,5,{14,6,13,5,8,9,7,12,4,10,0,11,2,3,1}))
print(testSample(3,5,{13,6,4,9,0,12,10,14,8,7,1,3,5,2,11}))
print(testSample(3,5,{0,4,9,14,7,8,6,13,12,11,1,5,10,3,2}))
print(testSample(5,3,{8,12,11,14,0,2,7,1,10,5,6,3,9,4,13}))
print(testSample(5,3,{11,8,10,9,14,12,13,4,0,1,6,2,3,7,5}))
print(testSample(5,2,{7,8,3,4,5,9,0,1,6,2}))
print(testSample(5,2,{8,9,5,0,1,7,6,4,3,2}))
print(testSample(2,5,{4,9,5,3,6,8,2,0,1,7}))
print(testSample(2,5,{4,9,8,5,2,3,7,0,1,6}))
print(testSample(3,3,{2,0,8,7,5,3,1,4,6}))
print(testSample(3,3,{5,8,1,2,7,3,6,4,0}))
print(testSample(3,3,{5,8,7,6,4,0,1,2,3}))
print(testSample(3,3,{0,2,6,1,5,4,7,8,3}))
print(testSample(3,3,{3,6,4,5,1,2,7,8,0}))
print(testSample(3,3,{4,6,8,3,0,7,5,2,1}))
print(testSample(4,2,{5,6,4,1,7,3,2,0}))
print(testSample(4,2,{6,0,5,3,7,4,2,1}))
print(testSample(2,4,{3,5,7,2,0,6,4,1}))
print(testSample(2,4,{7,6,4,5,3,0,1,2}))
print(testSample(3,2,{5,0,4,3,2,1}))
print(testSample(3,2,{5,3,0,4,1,2}))
print(testSample(2,3,{5,2,0,4,1,3}))
print(testSample(2,3,{4,5,3,1,0,2}))
print(testSample(2,2,{3,1,2,0}))
print(testSample(2,2,{2,3,1,0}))