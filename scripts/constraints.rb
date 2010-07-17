require 'enumeration_utils'

class IntegrityConstraint < CfgLineEnumerator
  def relevant_part( line )
    raise "relevant_part is not implemented."
  end

  def accept_file?( file_name )
    is_cfg?( file_name )
  end

  def each( &block )
    super do |line, file_name|
      part = relevant_part( line )
      if part
        yield part, file_name
      end
    end
  end
end
