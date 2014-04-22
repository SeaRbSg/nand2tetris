class CompilationEngine

  def compilewrite(output,xml,val)
    File.open(output, "a") { |f| f.write "<#{xml}> #{val} </#{xml}>\n" }
  end

 #Compile a complete class 
  def compileclass
    
  end

#Compile a static declaration or a field declaration
  def compileclassvardec(token)


  end

#Compile a complete method, function, or constructor
  def compilesubroutine

  end

#Compile a possibly empty parameter list, not including the ()
  def compileparameterlist

  end

#Compile a var declaration
  def compilevardec

  end

#Compile a sequence of statements, not including the {}
  def compilestatement

  end

#Compile a do statement
  def compiledo

  end

#Compile a let statement
  def compilelet

  end

#Compile a while statement
  def compilewhile

  end

#Compile a return statement
  def compilereturn

  end

#Compile an if statement, possibly with trailing else clause
  def compileif

  end

#Compile an express
  def compileexpression

  end

#Compile a term.  Must determine if current token is an idenifier.  Must distinguish between a variable, an arrary, and subrouting call.  A single lookahead token, which may be of [ ( or . suffices to distinguish between the three possibilities.  Any other token is not part of this term and shouldn't be advanced over.
  def compileterm

  end

#Compile a possibly empty comma-separated list of expressions
  def compileexpressionlist

  end

end