module PivotalAPI
  class Project < Base

    attr_accessor :updated_at, :bugs_and_chores_are_estimatable, :enable_planned_mode, :public, :story_ids, :name,
                  :iteration_length, :start_time, :version, :label_ids, :description, :profile_content,
                  :iteration_override_numbers, :velocity_averaged_over, :current_velocity, :point_scale_is_custom,
                  :epic_ids, :membership_ids, :integration_ids, :created_at, :week_start_day, :time_zone,
                  :shown_iterations_start_time, :has_google_domain, :kind, :id, :point_scale, :current_iteration_number,
                  :start_date, :number_of_done_iterations_to_show, :account_id, :labels

    class << self

      def fields
        ['description', 'labels', 'name']
      end

      def from_json(json)
        parse_json_project(json)
      end
      
      def retrieve(project_id)
        PivotalAPI::Service.project(project_id: project_id, fields: PivotalAPI::Project.fields)
      end
      
      protected

      def parse_json_project(project)
        new({
          id: project[:id].to_i,
          name: project[:name],
          week_start_day: project[:week_start_day],
          point_scale: project[:point_scale],
          labels: PivotalAPI::Label.from_json(project[:labels]),
          iteration_length: project[:iteration_length],
          current_velocity: project[:current_velocity]
        })
      end
      
    end
    
    def activity(opts={})
      opts[:project_id] = id
      
      PivotalAPI::Service.activity(opts)
    end
    
    def story(opts={})
      opts[:project_id] = id
      opts[:parameters] = {} unless opts[:parameters]
      opts[:parameters][:fields] = PivotalAPI::Story.fields
      
      PivotalAPI::Service.story(opts)
    end
    
    def stories(opts={})
      opts[:project_id] = id
      opts[:parameters] = {} unless opts[:parameters]
      opts[:parameters][:fields] = PivotalAPI::Story.fields
      
      PivotalAPI::Service.stories(opts)
    end
    
    def iterations(opts={})
      project_id = opts[:project_id]
      opts[:parameters] = {} unless opts[:parameters]
      opts[:fields] = PivotalAPI::Iteration.fields if opts[:fields].nil?
      
      PivotalAPI::Service.iterations(opts)
    end
    
    def current_iteration
      iterations.first
    end
    
    def previous_iteration
      iterations(scope: 'done').first
    end
    
    def next_iteration
      iterations(scope: 'backlog').first
    end

  end
  
  class Projects < Project
    
    class << self
      
      def retrieve()
        PivotalAPI::Service.projects(fields: PivotalAPI::Project.fields)
      end
    
      def from_json(json)
        parse_json_projects(json)
      end
    
      protected
    
      def parse_json_projects(json_projects)
        projects = Array.new
        json_projects.each { |project| projects << parse_json_project(project) }
        projects
      end
    
    end
    
  end
end