module UI
  class Controller < UIViewController
    include Eventable

    attr_accessor :navigation

    def initWithScreen(screen)
      @screen = screen
      init
      on(:view_did_load) { @screen.before_on_load}
      on(:view_did_load) { @screen.before_on_load}
      on(:view_will_appear) { @screen.before_on_show}
      on(:view_did_appear) { @screen.on_show}
      self
    end

    def loadView
      @screen.view.width = UIScreen.mainScreen.bounds.size.width
      @screen.view.height = UIScreen.mainScreen.bounds.size.height
      @screen.view.proxy.translatesAutoresizingMaskIntoConstraints = true
      self.view = @screen.view.proxy
    end

    def viewDidAppear(animated)
      super
      trigger(:view_did_appear)
    end

    def viewWillAppear(animated)
      super
      trigger(:view_will_appear)
    end

    def viewDidLoad
      super
      self.edgesForExtendedLayout = UIRectEdgeNone
      trigger(:view_did_load)
    end

    def viewWillTransitionToSize(size, withTransitionCoordinator:coordinator)
      super

      did_rotate = lambda do |context|
        @screen.view.width = size.width
        @screen.view.height = size.height
        @screen.view.update_layout
      end
      coordinator.animateAlongsideTransition(nil, completion:did_rotate)
    end
  end

  class Screen
    attr_accessor :navigation

    def initialize
      @navigation = nil
    end

    def before_on_load
      view.background_color = :white
      on_load
    end
    def on_load; end

    def before_on_show; end
    def on_show; end

    def view
      @view ||= UI::View.new
    end

    def proxy
      @proxy ||= Controller.alloc.initWithScreen(self)
    end
  end
end