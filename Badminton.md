cd\devkit
devkitvars
cd\ruby
rails new Badminton -d postgresql

cd Badminton

edit config/database.yml
  username: postgres 
  password: admin

rails db:create

rails g controller pages home
modify routes.rb
 # You can have the root of your site routed with "root"
   root 'pages#home'

Modify Gemfile
  gem 'bootstrap-sass'
  gem 'carrierwave'
bundle update

edit pages.scss
    @import "bootstrap";

Bootsrap
========
modify home.html.erb to check that bootstrap is included or not 
<div class ="page-header text-center" > 
  <h1>Home</h1>
</div>

rails g scaffold event abbr name no_of_players:integer sequence:integer
modify migration
rails db:migrate

rails g scaffold round name sequence:integer
rails db:migrate

rails g scaffold country name flag
modify migration
rails db:migrate

rails g uploader flag

edit country model
  mount_uploader :flag, FlagUploader
  default_scope { order('name') }

rails g scaffold tournament name fm_date:date to_date:date country:references 
modify migration
rails db:migrate

rails g migration add-chosen-to-tournaments chosen:boolean
modify migration
    add_column :tournaments, :chosen, :boolean, default: false

Modify tournament controller
    def tournament_params
      params.require(:tournament).permit(:name, :fm_date, :to_date, :country_id, :chosen)
    end

rails g scaffold player first_name last_name country:references image
rails db:migrate

rails g uploader image

edit player model
  mount_uploader :image, ImageUploader
  default_scope { order('first_name,last_name') }

rails g scaffold team event:references rank:integer player1_id:integer player2_id:integer 
rails db:migrate

rails g migration drop-rank-from-teams
rails db:migrate

edit team model
  belongs_to :event
  belongs_to :player1, :class_name => 'Player'
  belongs_to :player2, :class_name => 'Player'  
  default_scope { order("event_id") }

  # Getter
  def team_name
    [event.abbr, player1.full_name, player2.full_name].join(' / ')
  end
  
  # Setter
  def team_name=(name)
    split = name.split(' / ', 3)
    self.event.abbr = split.first
    self.player1.name = split.second
    self.player2.name = split.last
  end

edit team/index.html
<div class ="page-header text-center" > 
  <%= link_to 'New Team', new_team_path,
  :class => "btn btn-success pull-right"  %>
  <h1>Teams</h1>
</div>

<table id="teams" class="table table-striped table-hover">

rails g scaffold entry tournament:references team:references rank:integer
modify migration
  create_table :entries, {:id => false} do |t|
  add_index :entries, [:tournament_id, :team_id], unique: true
rails db:migrate

Edit gem file
gem 'composite_primary_keys', '=9.0.4'

Modify entry model
  self.primary_keys = :tournament_id, :team_id
  belongs_to :tournament
  belongs_to :team

Modiy entries/_form.html
  <div class="field">
    <%= f.label :tournament_id %>
    <%= f.collection_select :tournament_id, Tournament.where('chosen = TRUE'), :id, :name %>
  </div>


rails g scaffold match tournament:references date:date round:references team1_id:integer team2_id:integer
rails db:migrate

edit match model
  belongs_to :tournament
  belongs_to :round
  belongs_to :team1, :class_name => 'Team'
  belongs_to :team2, :class_name => 'Team'  
  has_one :result, dependent: :destroy
  default_scope { includes(:tournament).includes(:team1).order("tournaments.name","date desc","event_id asc") }

rails g scaffold result match:references game11:integer game12:integer 
game21:integer game22:integer game31:integer game32:integer
modify migration default: 0
rails db:migrate

dataTable
=========
edit gem file
  gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
bundle update

Run the install generator:
--------------------------
rails generate jquery:datatables:install bootstrap3

This will add to the corresponding asset files

# app/assets/javascripts/application.js
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap

# app/assets/stylesheets/application.css
*= require dataTables/bootstrap/3/jquery.dataTables.bootstrap

Initialize your datatables using these option:

$('#datatable').dataTable({
  // ajax: ...,
  // autoWidth: false,
  // pagingType: 'full_numbers',
  // processing: true,
  // serverSide: true,

  // Optional, if you want full pagination controls.
  // Check dataTables documentation to learn more about available options.
  // http://datatables.net/reference/option/pagingType
});  

edit player/index.html
<div class ="page-header text-center" > 
  <%= link_to 'New Player', new_player_path,
  :class => "btn btn-success pull-right"  %>
  <h1>Players</h1>
</div>

  <table id="players" class="table table-striped table-hover">  

       <!-- start of buttons -->
        <td><%= link_to 'Show', match, :class => " btn btn-success btn-xs active"  %></td>
        <td><%= link_to 'Edit', edit_match_path(match), 
                :class => " btn btn-warning btn-xs active" %></td>
        <td><%= link_to 'Destroy', match, method: :delete, data: { confirm: 'Are you sure?' },     :class => " btn btn-danger btn-xs active" %></td>

edit players.coffee
jQuery ->
        $('#players').dataTable({
        pagingType: 'full_numbers', 
        order: [[ 0, "asc" ],[ 1, "asc" ]]         
        }) 

rails g scaffold match tournament:references number:integer date:date session:references player1_id:integer player2_id:integer 

edit model match
  belongs_to :player1, :class_name => 'Player'
  belongs_to :player2, :class_name => 'Player'

rails db:migrate

edit match/index.html
<div class ="page-header text-center" > 
  <%= link_to 'New Match', new_match_path,
  :class => "btn btn-success pull-right"  %>
  <h1>Matches</h1>
</div>

  <table id="matches" class="table table-striped table-hover">  

       <!-- start of buttons -->
        <td><%= link_to 'Show', match, :class => " btn btn-success btn-xs active"  %></td>
        <td><%= link_to 'Edit', edit_match_path(match), 
                :class => " btn btn-warning btn-xs active" %></td>
        <td><%= link_to 'Destroy', match, method: :delete, data: { confirm: 'Are you sure?' },     :class => " btn btn-danger btn-xs active" %></td>

edit matches.coffee
jQuery ->
        $('#matches').dataTable({
        pagingType: 'full_numbers', 
        order: [[ 0, "asc" ],[ 1, "asc" ]]         
        }) 
--------------------------------------------------------------------------------------------
rails g scaffold result match:references player1_frames:integer player2_frames:integer 
rails db:migrate

rails g scaffold standing team:references wins:integer draws:integer losses:integer
goals_for:integer goals_against:integer points:integer  
rails db:migrate
edit db/seeds.rb
20.times{ |i| Standing.where(team_id: i, wins: 0, draws: 0, losses: 0,
  goals_for: 0, goals_against: 0, points: 0).first_or_create}
rails db:seed

edit model/result
  belongs_to :match
  before_save :assign_points
  before_destroy :deduct_points
  
  private
  def assign_points

    home_wins = 0
    home_losses = 0
    home_draws = 0
    home_points = 0
    away_wins = 0
    away_losses = 0
    away_draws = 0  
    away_points = 0 
    if self.home_goals > self.away_goals
      home_wins = 1
      away_losses = 1
      home_points = 3
      away_points = 0 
    elsif self.home_goals < self.away_goals
      away_wins = 1
      home_losses = 1
      home_points = 0
      away_points = 3
    elsif self.home_goals = self.away_goals
      home_draws = 1  
      away_draws = 1  
      home_points = 1
      away_points = 1   
    end
          
    standing = Standing.find(self.match.home_id)
    standing.wins = standing.wins + home_wins
    standing.losses = standing.losses + home_losses
    standing.draws = standing.draws + home_draws  
    standing.goals_for = standing.goals_for + self.home_goals
    standing.goals_against = standing.goals_against + self.away_goals 
    standing.points = standing.points + home_points       
    standing.save   

    standing = Standing.find(self.match.away_id)
    standing.wins = standing.wins + away_wins
    standing.losses = standing.losses + away_losses
    standing.draws = standing.draws + away_draws  
    standing.goals_for = standing.goals_for + self.away_goals
    standing.goals_against = standing.goals_against + self.home_goals 
    standing.points = standing.points + away_points
    standing.save
  end       

  
  def deduct_points
   
    home_wins = 0
    home_losses = 0
    home_draws = 0
    away_wins = 0
    away_losses = 0
    away_draws = 0    
    if self.home_goals > self.away_goals
      home_wins = 1
      away_losses = 1
      home_points = 3
      away_points = 0
    elsif self.home_goals < self.away_goals
      away_wins = 1
      home_losses = 1
      home_points = 0
      away_points = 3
    elsif self.home_goals = self.away_goals
      home_draws = 1  
      away_draws = 1  
      home_points = 1
      away_points = 1   
    end
    
    standing = Standing.find(self.match.home_id)
    standing.wins = standing.wins - home_wins
    standing.losses = standing.losses - home_losses
    standing.draws = standing.draws - home_draws  
    standing.goals_for = standing.goals_for - self.home_goals
    standing.goals_against = standing.goals_against - self.away_goals 
    standing.points = standing.points - home_points       
    standing.save   

    standing = Standing.find(self.match.away_id)
    standing.wins = standing.wins - away_wins
    standing.losses = standing.losses - away_losses
    standing.draws = standing.draws - away_draws  
    standing.goals_for = standing.goals_for - self.away_goals
    standing.goals_against = standing.goals_against - self.home_goals 
    standing.points = standing.points - away_points       
    standing.save
  end       
   

dataTable
=========
edit gem file
  gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
bundle update

Run the install generator:
--------------------------
rails generate jquery:datatables:install bootstrap3

This will add to the corresponding asset files

# app/assets/javascripts/application.js
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap

# app/assets/stylesheets/application.css
*= require dataTables/bootstrap/3/jquery.dataTables.bootstrap

Initialize your datatables using these option:

$('#datatable').dataTable({
  // ajax: ...,
  // autoWidth: false,
  // pagingType: 'full_numbers',
  // processing: true,
  // serverSide: true,

  // Optional, if you want full pagination controls.
  // Check dataTables documentation to learn more about available options.
  // http://datatables.net/reference/option/pagingType
});

edit index.html
---------------
<div class ="page-header text-center" > 
  <%= link_to 'New Fixture', new_match_path,
  :class => "btn btn-success pull-right"  %>
  <h1>Fixtures</h1>
</div>

  <table id="matches" class="table table-striped table-hover"> 

       <!-- start of buttons -->
        <td><%= link_to 'Show', match, :class => " btn btn-success btn-xs active"  %></td>
        <td><%= link_to 'Edit', edit_match_path(match), 
                :class => " btn btn-warning btn-xs active" %></td>
        <td><%= link_to 'Destroy', match, method: :delete, data: { confirm: 'Are you sure?' },     :class => " btn btn-danger btn-xs active" %></td>

edit matches.coffee
jQuery ->
        $('#matches').dataTable({
        pagingType: 'full_numbers', 
        order: [[ 0, "asc" ]]         
        })    	

Create menu
===========
1) Modify views\layouts\application.html.erb

  <body>
    <nav class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">

        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a href="#" class="navbar-brand">Euro 2016</a>
        </div> <!--end navbar-header -->

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div id="navbar" class="collapse navbar-collapse">
          <ul class="nav navbar-nav navbar-right">
            <li><%= link_to 'Home', root_path %></li>
            <li><%= link_to 'Fixtures', matches_path %></li>    
            <li><%= link_to 'Results', results_path %></li>
            <li><%= link_to 'Standings', standings_path %></li>    
          </ul>
        </div><!--end of collapse navbar-collapse -->

      </div> <!-- end of container -->
    </nav>  <!-- End of nav element --> 
    <div class="container bodyContent"> <!-- from Bootstrap for Rails -->
      <%= yield %>
    </div> <!-- end of container -->

  </body>


2) Modify application.css to increase space between menu and content
  .bodyContent {
  margin-top: 50px;
  } 

rails g scaffold Score match:references side minute:integer plus:integer kind

rails g model Criterium show_date:date (Singular form of Criteria)
(Naming show_date instead of date to prevent same column name in more than one
table. But that's unneccessary as we can prefix table name, e.g. criterium.date)

if want to rename column 
rails g migration change_date_to_show_date
    rename_column :criteria, :date, :show_date

rails g migration add_criterium_id_to_matches
        add_column :matches, :criterium_id, :integer
using psql to update criterium_id to 1
  UPDATE matches SET criterium_id = 1;

edit match model
  belongs_to :criterium

edit matches controller
  @matches = Fixture.joins(:criterium).where("matches.date >= criteria.show_date")

If collapsible menu doesn't work, must copy bootstap.min.js to app\assets\javascripts folder

Priority of order sequence
--------------------------
In case of collection_select, order will base on default scope in model. If want to override order to order clause in collection_select specification, must delete default scope in model.