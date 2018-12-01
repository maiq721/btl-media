class RoomsController < ApplicationController
    before_action :config_opentok,:except => [:index]
    def index
      @rooms = Room.where(:public => true)
      @room = Room.new
    end
    
    def create
      session = @opentok.create_session
      params[:room][:session_id] = session.session_id
  
      @room = current_user.rooms.build(room_params)
  
      respond_to do |format|
        if @room.save
          format.html { redirect_to("/party/"+@room.id.to_s) }
        else
          format.html { render :controller => 'rooms',
            :action => "index" }
        end
      end
    end
  
    def destroy
      @room = Room.find_by id: params[:id]
      @room.destroy
      redirect_to root_path
    end
  
    def party
      @room = Room.find(params[:id])
  
      @tok_token = @opentok.generate_token(@room.session_id)
    end
  
    private
    def config_opentok
      if @opentok.nil?
       @opentok = OpenTok::OpenTok.new("46228102", "89bbe3aabeb7433bacce22047f2e66ade7e51076")
      end
    end
  
    def room_params
      params.require(:room).permit(:name, :public, :session_id)
    end
  end