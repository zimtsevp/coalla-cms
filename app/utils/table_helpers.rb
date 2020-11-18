class TableHelpers

  class SimpleFormatter
    def format_value(item, format)
      case format
        when Proc
          format.call(item)
        else
          item
      end
    end
  end

  class BooleanFormatter < SimpleFormatter

    def format_value(item, format)
      case format
        when Proc
          format.call(item)
        when String
          item ? format : ''
        when Hash
          case item
            when true
              format[:true].presence || format[:yes].presence || ''
            else
              format[:false].presence || format[:no].presence || ''
          end
        else
          item ? '<i class="glyphicon glyphicon-check"></i>'.html_safe : ''
      end
    end

    def align
      :center
    end

  end

  class DateFormatter < SimpleFormatter

    DATE = '%d.%m.%Y'

    def initialize(default_format)
      @default_format = default_format
    end

    def format_value(item, format)
      if item
        item = item.localtime if item.respond_to?(:localtime)
        case format
          when String
            Russian::strftime(item, format)
          when Proc
            format.call(item)
          when :date
            Russian::strftime(item, DATE)
          else
            Russian::strftime(item, @default_format)
        end
      else
        ''
      end
    end

  end

  class EnumerizeFormatter < SimpleFormatter

    def format_value(item, format)
      case format
        when Proc
          format.call(item)
        else
          item.try(:text)
      end
    end

  end

  class SelfHelper

    def format_value(item, format)
      raise "Format should be lambda" unless format.is_a? Proc
      format.call(item)
    end

  end

  class MethodHelper

    FORMATS = {
        boolean: BooleanFormatter.new,
        date: DateFormatter.new(DateFormatter::DATE),
        datetime: DateFormatter.new('%d.%m.%Y %H:%M'),
        enumerize: EnumerizeFormatter.new
    }
    FORMATS.default = SimpleFormatter.new

    def initialize(method, type)
      @method = method
      @formatter = FORMATS[type]
    end

    def format_value(item, format)
      @formatter.format_value(item.send(@method), format)
    end

    def align
      @align || @formatter.respond_to?(:align) && @formatter.align || :left
    end

    def align=(value)
      @align = value
    end

    def respond_to?(method)
      return (@align.present? || @formatter.respond_to?(method)) if method == :align
      super
    end

  end

  class ReflectionHelper

    def initialize(method, template)
      @method = method
      @template = template
    end

    def format_value(item, format)
      target = item.send(@method)
      case format
        when Proc
          format.call(target)
        when Hash, nil
          if target
            options = {label_attr: :id, type: :link, target: :_blank}.merge(format || {})
            v = target.send(options[:label_attr])
            case options[:type]
              when :link
                @template.link_to(v, target, target: options[:target])
              else
                v.to_s
            end
          else
            ''
          end
        else
          target.to_s
      end
    end

  end

  def initialize(model_class, template)
    @model_class = model_class
    @columns = model_class.columns.index_by(&:name).with_indifferent_access
    @reflections = model_class.reflections.dup.with_indifferent_access
    @template = template
    @helpers = {}
  end

  def self.for(model_class, template)
    TableHelpers.new(model_class, template)
  end

  def [](method)
    helper = @helpers[method]
    unless helper
      helper = case method
                 when :self
                   SelfHelper.new
                 else
                   r = @reflections[method]
                   if r
                     if r.macro == :belongs_to
                       ReflectionHelper.new(method, @template)
                     end
                   else
                     if @model_class.respond_to?(:enumerized_attributes) && @model_class.enumerized_attributes[method]
                       type = :enumerize
                     else
                       type = @columns[method] && @columns[method].type || :default
                     end
                     h = MethodHelper.new(method, type)
                     h.align = :right if [:integer, :decimal].include?(type.to_sym)
                     h
                   end
               end
      @helpers[method] = helper
    end
    helper
  end

end