classdef(Abstract) InternetSearchEngine
    %INTERNETSEARCHENGINE Superclass for internet search engine classes
    %   Search engines in this repository should inherit from this class
        
    methods (Abstract)
        search(obj)
    end

end