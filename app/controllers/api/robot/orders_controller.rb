class Api::Robot::OrdersController < ApplicationController 

  # This method find whether the current point is within the table space or not
  def validPoint(x,y)
    return (x>=0 && x<5) && (y>=0 && y<5)
  end

  # This method looks for the PLACE command and returns its index
  def findIndex(data)
    index = -1
    for k in 0..data.length-1
      if data[k] == "PLACE" && k<data.length-1
        index = k + 1
        break
      end
    end
    return index
  end

  # This method will move the robot in the direction it is currently facing
  def moveRobot(p1,p2,orientation)
    cp1 = p1
    cp2 = p2

    if orientation == "EAST"
      if validPoint(cp1,cp2+1)
        cp2 = cp2+1  
      else
        cp1 = false
        cp2 = false        
      end
    elsif orientation == "WEST"
      if validPoint(cp1,cp2-1)
        cp2 = cp2-1        
      else
        cp1 = false
        cp2 = false        
      end
    elsif orientation == "NORTH"
      if validPoint(cp1-1,cp2)
        cp1 = cp1-1        
      else
        cp1 = false
        cp2 = false        
      end
    elsif orientation == "SOUTH"        
        if validPoint(cp1+1,cp2)
          cp1 = cp1+1          
        else
          cp1 = false
          cp2 = false          
        end
    end

    return cp1, cp2

  end

  # This method turns the robot according to the specified direction i.e.., left or right 90deg
  def changeOrientation(changeTo,orientation)
    current_orientation = orientation

    if orientation == "EAST" && changeTo == "LEFT"
      current_orientation = "NORTH"      
    elsif orientation == "EAST" && changeTo == "RIGHT"
      current_orientation = "SOUTH"
    elsif orientation == "WEST" && changeTo == "LEFT"
      current_orientation = "SOUTH"      
    elsif orientation == "WEST" && changeTo == "RIGHT"
      current_orientation = "NORTH"      
    elsif orientation == "NORTH" && changeTo == "LEFT"
      current_orientation = "WEST"      
    elsif orientation == "NORTH" && changeTo == "RIGHT"
      current_orientation = "EAST"      
    elsif orientation == "SOUTH" && changeTo == "LEFT"
      current_orientation = "EAST"      
    elsif orientation == "SOUTH" && changeTo == "RIGHT"
      current_orientation = "WEST"      
    end
    return current_orientation
  end

  # This method is like a master method which calls the particular method and saves the result.  
  def runCommand(p1,p2,data,orientation,start)
    current_p1 = p1
    current_p2 = p2
    current_orientation = orientation

    for x in start..data.length-1
      if data[x] == "MOVE"
        cp1,cp2 = moveRobot(current_p1,current_p2,current_orientation)
        if(cp1!=false && cp2!=false)
          current_p1 = cp1
          current_p2 = cp2          
        end
      elsif data[x] == "LEFT"
        current_orientation = changeOrientation("LEFT",current_orientation)
      elsif data[x] == "RIGHT"
        current_orientation = changeOrientation("RIGHT",current_orientation)
      elsif data[x] == "REPORT"
        break
      end
    end
    return current_p1,current_p2,current_orientation    
  end


  def create
    commands = orders_params[:Commands]
    data = commands.split(',')

    roboStartIndex = findIndex(data)

    p1,p2,direction = runCommand(data[roboStartIndex].to_i,data[roboStartIndex+1].to_i,data,data[roboStartIndex+2],roboStartIndex+3)

    # Final Solution
    result = [p1,p2,direction]

    render json: {status: "success", location: result}
  end

  private

  def orders_params
    params.permit([:Commands])
  end
end
