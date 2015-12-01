module VotesHelper
	def vote_body(vote)
		"<table style = 'width: 100%;'>
			<tr>
				<td valign = 'middle' align = 'left'  style='height: 45px;'>
					<span class = 'istring_m norm'>Автор опроса: </span>#{link_to vote.user.name, vote.user, :class => 'b_link_i'}	#{voteInformation(vote)}
				</td>
				<td valign = 'middle' align = 'right' style='height: 45px;'>
					<p class = 'istring_m norm'>Голосование #{'было' if vote_completed?(vote)} активно с #{my_time(vote.start_date)} по #{my_time(vote.end_date)}</p>
				</td>
			</tr>
			<tbody id = 'middle'>
				<tr>
				<td  colspan = '2'>
					<div class = 'm_1000wh'>
						<span id = 'content' class = 'mText'><p>#{vote.content_html}</p></span>
						<div id = 'vtValues'>
					    #{vote_values_table(vote)}
						</div>
					</div>
				</td>
				</tr>
			</tbody>
		</table>		
		"
	end
	
	def vote_show_block
		html = vote_body(@vote)
		p = {
				:tContent => html, 
				:classLvl_1 => 'even', 
				:classLvl_2 => 'm_1000wh tb-pad-m'
			}
		return c_box_block(p)
	end
	
	def voteInformation(vote)
		''
	end
	
	def vote_show_buttons
		b = []
    b += [{:name => "К списку опросов", :access => true, :type => 'arrow-right', :link => votes_path}]
    b += [{:name => "Удалить опрос", :access => userCanEditVote?(@vote), :type => 'trash', :link => vote_path(@vote), :data_method => 'delete', :data_confirm => 'Вы уверены, что хотите удалить данное голосование?', :rel => 'nofollow'}]
	  return control_buttons(b)
  end
	
	def vote_values_table(vote)
		v = "<span class = 'istring_m norm'>Нет ни одного варианта ответа...</span>"
		vv = vote.vote_values.order("created_at DESC")
		if vv != []
			v = ''
      i = 0
			vv.each do |val|
				i += 1
        oddity = (i.odd?)? 'vt-odd' : "vt-even"
				v += "
             <div class = 'm_1000wh #{oddity}'>
               <div class = 'tb-pad-s m_95p'>
                 #{val.value}
      					 <div class = 'section group' id = 'voteVal#{val.id}'>
      						  #{vote_result_row(val)}
      					 </div>
               </div>
             </div>					
					 "
			end
			v = "<br/><b>Варианты:</b>#{v}"
		end
		return v
	end
	def percent_voices(val)
		vote_voices = val.vote.voices.count.to_f
		voices = val.voices.count.to_f
		p = 0.5
		if vote_voices > 0.0 and voices > 0.0
			p = voices*100/vote_voices
		end
		return p
	end
	
	def index_votes_buttons
		[
		 {:name => "Добавить опрос", :access => !is_not_authorized?, :type => 'plus', :link => "#{new_vote_path}", :id => 'newVote'} 
		]
	end
	
	
	def vote_result_row(val)
		v = ""
		p = percent_voices(val)
		if user_could_see_vote_result?(val.vote)
			v =	"
				 <div class = 'col span_9_of_12 vt-voice-line'>
						<div style = 'width: #{p}%;'>
						</div>
				 </div>
				 <div class = 'col span_3_of_12 vt-voice-count'>
						#{val.voices.count} (#{p.to_i}%)
				 </div>
				"
		else
			if user_type == 'guest'
				v = "<div class = 'col span_12_of_12'><p class = 'istring norm medium-opacity'>Чтобы проголосовать, необходимо войти на сайт</p></div>"
			else
				if val.vote.user == current_user
					v = "
						<div class = 'col span_10_of_12'>
              <a style = 'cursor: pointer;' class = 'b_link' id = 'giveVoice' vote-id = \"#{val.vote.id}\" vote-value-id = \"#{val.id}\">
                Голосовать
              </a>
            </div>
						<div class = 'col span_10_of_12 vt-voice-count'>
							#{val.voices.count} (#{p.to_i}%)
						</div>
						"
				else
					v = "<div class = 'col span_12_of_12'><a style = 'cursor: pointer;' class = 'b_link' id = 'giveVoice' vote-id = \"#{val.vote.id}\" vote-value-id = \"#{val.id}\">Голосовать</a></div>"
				end
			end
		end
		return v
	end
	
	def vote_errors 
		@content_error = "" 
		@content_f_class = "norm"
    @vote_values_error = ""
    @vote_values_f_class = "norm"
		if @vote.errors[:content] != [] and @vote.errors[:content] != nil
			@content_f_color = "err"
			@vote.errors[:content].each do |err|
				@content_error += "#{err}<br />"
			end
		end
		if @vote.errors[:added_vote_values] != [] and @vote.errors[:added_vote_values] != nil
			@vote_values_f_color = "err"
			@vote.errors[:added_vote_values].each do |err|
				@vote_values_error += "#{err}<br />"
			end
		end
	end
end
