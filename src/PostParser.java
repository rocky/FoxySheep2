/*
 * Copyright (c) 2015, Robert Jacobson
 * All rights reserved. 
 * 
 * Licensed under the BSD license. See LICENSE.txt for details.
 * 
 * Author(s): Robert Jacobson
 * 
 * Description: This class rewrites the parse tree generated by ANTLR4. 
 * 				It "flattens" flat operators that ANTLR parses as left 
 * 				associative.
 * 
 */

import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.ParserRuleContext;
//import org.antlr.v4.runtime.misc.NotNull;
//import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;

/**
 * This class is a subclass of {@link FoxySheepBaseListener} that rewrites the
 * parse tree generated by ANTLR4. It "flattens" flat operators that ANTLR
 * parses as left associative.
 */
public class PostParser extends FoxySheepBaseListener {
	
	public static void main(String[] args) throws Exception{
		FoxySheep.main(args);
	}
	
	/**
	 * {@inheritDoc}
	 *
	 * <p>This takes a ParserRuleContext of a binary operator and "flattens"
	 * the operator if one of its operands is the same binary operator context.</p>
	 */
	public void flatten(ParserRuleContext ctx){
		/* This function only flattens if the operator is the same and also 
		 * keeps the operators intact. 
		 *
		 * Since ANTLR4 parses this operator as left associative, we only
		 * need to check the left hand side expr.
		 */
		
		//If the child isn't the same construct, nothing to do.
		if(!(ctx.getChild(0).getClass() == ctx.getClass())) return;
		
		ParserRuleContext lhs = (ParserRuleContext)ctx.getChild(0);
		ParseTree rhs = ctx.getChild(2);
		TerminalNode op = (TerminalNode)ctx.getChild(1);
		
		/*If the operator of the nested Context isn't the same, nothing to do.
		 *The operator is always in position 1 for infix operators. We do this
		 *check because some Contexts that use the same context for multiple
		 *operators.
		*/
		if(  !op.getText().equals(lhs.getChild(1).getText()) ) return;
		
		//Clear all children.
		ctx.children.clear();

		//Add all children of lhs. (Also adds the operator of the lhs.)
		ctx.children.addAll(  lhs.children  );

		//Finally, add the rhs back in.
		ctx.children.add(rhs);
	}


	/**
	 * {@inheritDoc}
	 *
	 * <p>Inequality[]</p>
	 */
	@Override public void exitComparison(FoxySheepParser.ComparisonContext ctx) {
		/* This function flattens keeps the operators intact. It differs from 
		 * flatten() in that we flatten if the class is the same but don't check
		 * if the operator is the same. 
		 */
		
		//If the child isn't the same construct, nothing to do.
		if(!(ctx.getChild(0).getClass() == ctx.getClass())) return;
		
		ParserRuleContext lhs = (ParserRuleContext)ctx.getChild(0);
		ParseTree rhs = ctx.getChild(2);
		TerminalNode op = (TerminalNode)ctx.getChild(1);
		
		/*
		 * This is where we differ from flatten(). We don't do the following
		 * check.
		*/
		//if(  !op.getText().equals(lhs.getChild(1).getText()) ) return;
		
		ctx.children.clear();
		ctx.children.addAll(  lhs.children  );
		ctx.children.add(op); //We keep all operators intact.
		ctx.children.add(rhs);
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>Composition[expr1,expr2]	e@*e@*e.</p>
	 */
	@Override public void exitCompoundExpression(FoxySheepParser.CompoundExpressionContext ctx) {
		/* ANTLR4 parses this rule as right associative for some reason, so
		 * we cannot use flatten(). The code is actually much simpler than
		 * flatten because of the right associativity. 
		 */
		int childCount = ctx.getChildCount();
		
		//If there is no RHS, nothing to do.
		if(childCount < 3) return;
		//If the RHS child isn't the same construct, nothing to do.
		if( !(ctx.getChild(childCount-1).getClass() == ctx.getClass()) ) return;
		
		ParserRuleContext rhs = (ParserRuleContext)ctx.getChild(childCount-1);
		//Remove RHS child.
		ctx.removeLastChild();
		//Add all children of rhs. (Also adds the operator of the rhs.)
		ctx.children.addAll(  rhs.children  );
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>Composition[expr1,expr2]	e@*e@*e.</p>
	 */
	@Override public void exitComposition(FoxySheepParser.CompositionContext ctx) {
		flatten(ctx);
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>RightComposition[expr1,expr2]	e/*e/*e</p>
	 */
	@Override public void exitRightComposition(FoxySheepParser.RightCompositionContext ctx) {
		flatten(ctx);
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>StringJoin[expr1,expr2]	e<>e<>e</p>
	 */
	@Override public void exitStringJoin(FoxySheepParser.StringJoinContext ctx) {
		flatten(ctx);
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>SmallCircle[expr1,expr2]	eoeoe</p>
	 */
	@Override public void exitSmallCircle(FoxySheepParser.SmallCircleContext ctx) {
		
		flatten(ctx);
	}
	
	/**
	 * {@inheritDoc}
	 *
	 * <p>Parsing Span nodes is a complete mess. This method essentially reparses
	 * node sequences of the form expr? (;; expr?)+.</p>
	 */
	public void rewriteSpan(ParserRuleContext ctx){
		ArrayList<Integer> opIndex = new ArrayList<Integer>();
		ArrayList<Integer> spanExpressions = new ArrayList<Integer>();
		
		FoxySheepParser.SpanAContext span;
		
		int i, j, nextOp;
		
		//Identify locations of ";;".
		for(i = 0; i < ctx.children.size(); i++){
			if(ctx.children.get(i).getText().equals(";;")){
				opIndex.add(i);
			}
		}
		
		
		for(i = 0, nextOp = 0; i < ctx.children.size() && nextOp < opIndex.size(); i++, nextOp++){
			//The index i always points to the first child in a Span expression,
			//and index j always points to the current child of the current span
			//expression.
			j=i; //We are at the beginning of a span expression.
			//We move j to the end of this span expression by looking for a second ";;".
			
			if( nextOp + 1 < opIndex.size() //There is a next ";;"
					&& opIndex.get(nextOp+1) + 1 < ctx.children.size() //There is a node after the next ";;"
					&& ctx.children.get(opIndex.get(nextOp+1) + 1) instanceof FoxySheepParser.ExprContext ) {
				//There is a second ";;" followed by an expr. 
				i = opIndex.get(nextOp+1) + 1;
				spanExpressions.add(i);
				nextOp++; //We want nextOp to end at the last ";;" of the current expression.
			} else{
				//There is no second ";;" belonging to this expression.
				if( opIndex.get(nextOp) + 1 < ctx.children.size() //There is a node after ";;"
						&& ctx.children.get(opIndex.get(nextOp) + 1) instanceof FoxySheepParser.ExprContext ) {
					//This span expression ends in an expr.
					i = opIndex.get(nextOp) + 1;
					spanExpressions.add(i);
				} else{
					//This span expression ends in the current ";;".
					i = opIndex.get(nextOp);
					spanExpressions.add(i);
				}
			}
		}//end for
		
		//At this point spanExpressions holds the index of the last child of each span expression. It might be
		//that after all of this there is nothing to do.
		if(spanExpressions.size() == 1) return;
		//Otherwise there is more than one span expression, and we need to rewrite the tree replacing the 
		//Span?Context this method was invoked on with a TimesContext.
		FoxySheepParser.TimesContext timesctx = new FoxySheepParser.TimesContext((FoxySheepParser.ExprContext)ctx);
		//How much of the following is necessary?
		timesctx.children = new ArrayList<ParseTree>();
		timesctx.parent = ctx.parent;
		
		//Add each span expression as a child to timesctx.
		for(i = 0, j = 0; i < spanExpressions.size(); i++ ){
			//i is the index of the current span expression in spanExpressions, 
			//and j is the index to the beginning of the new span expressions children in ctx.children.
			//We make new SpanAContext objects for each span expression.
			span = new FoxySheepParser.SpanAContext((FoxySheepParser.ExprContext)ctx);
			//How much of this is necessary?
			span.children = new ArrayList<ParseTree>();
			span.parent = timesctx;
			for(int n = j; n<=spanExpressions.get(i); n++){
				span.children.add(ctx.children.get(n));
			}
			timesctx.children.add(span);
			//update j to be the beginning of the next expression.
			j = spanExpressions.get(i) + 1;
		}
		
		//Finally, detach the span this method was invoked on from its parent and replace with the TimesContext.
		if(ctx.getParent() != null){
			List<ParseTree> parentsChildren = ctx.getParent().children; 
			parentsChildren.add( parentsChildren.indexOf(ctx) , timesctx);
			parentsChildren.remove(ctx);
		}
		ctx.parent = timesctx;
		//...I think that's it.
	}
	
	/**
	 * {@inheritDoc}
	 *
	 * <p>Parsing Span nodes is a complete mess.</p>
	 * <p>Span[expr1,expr2,expr3] e;;e;;e</p>
	 */
	@Override public void exitSpanA(FoxySheepParser.SpanAContext ctx) {
		//Flatten
		//If there is no RHS expr, nothing to do.
		if(ctx.expr().size()==1) return;
		//Get the RHS expr.
		ParseTree rhs = ctx.expr(1);
				
		//If the RHS child isn't a SpanA, nothing to do.
		if(!(rhs instanceof FoxySheepParser.SpanAContext)) return;

		//Remove the last expr.
		ctx.removeLastChild();
		//Replace it with its children.
		ctx.children.addAll(  ((ParserRuleContext)rhs).children  );
		
		//If this is the topmost Span context, rewrite the tree.
		if(! (ctx.parent instanceof FoxySheepParser.SpanAContext 
				|| ctx.parent instanceof FoxySheepParser.SpanBContext) )
		{
			rewriteSpan(ctx);
		}
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>Parsing Span nodes is a complete mess.</p>
	 * <p>Span[expr1,expr2,expr3] e;;e;;e</p>
	 */
	@Override public void exitSpanB(FoxySheepParser.SpanBContext ctx) {
		//Flatten
		//If there is no RHS expr, nothing to do.
		if(ctx.expr().size()==0) return;
		//Get the RHS expr.
		ParseTree rhs = ctx.expr(0);
				
		//If the RHS child isn't a SpanA, nothing to do.
		if(!(rhs instanceof FoxySheepParser.SpanAContext)) return;

		//Remove the last expr.
		ctx.removeLastChild();
		//Replace it with its children.
		ctx.children.addAll(  ((ParserRuleContext)rhs).children  );
		
		//If this is the topmost Span context, rewrite the tree.
		if(! (ctx.parent instanceof FoxySheepParser.SpanAContext 
				|| ctx.parent instanceof FoxySheepParser.SpanBContext) )
		{
			rewriteSpan(ctx);
		}
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>CircleDot[expr1,expr2]		eoeoe</p>
	 */
	@Override public void exitCircleDot(FoxySheepParser.CircleDotContext ctx) {
		flatten(ctx);
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>NonCommutativeMultiply[expr1,expr2]		e**e**e</p>
	 */
	@Override public void exitNonCommutativeMultiply(FoxySheepParser.NonCommutativeMultiplyContext ctx) {
		flatten(ctx);
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>Cross[expr1,expr2]		exexe</p>
	 */
	@Override public void exitCross(FoxySheepParser.CrossContext ctx) {
		flatten(ctx);
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>Dot[expr1,expr2]		e.e.e</p>
	 */
	@Override public void exitDot(FoxySheepParser.DotContext ctx) {
		flatten(ctx);
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>Diamond[expr1,expr2]		exexe</p>
	 */
	@Override public void exitDiamond(FoxySheepParser.DiamondContext ctx) {
		flatten(ctx);
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>Wedge[expr1,expr2]		eAeAe</p>
	 */
	@Override public void exitWedge(FoxySheepParser.WedgeContext ctx) {
		flatten(ctx);
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>Vee[expr1,expr2]		eVeVe</p>
	 */
	@Override public void exitVee(FoxySheepParser.VeeContext ctx) {
		flatten(ctx);
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>CircleTimes[expr1,expr2]		exexe</p>
	 */
	@Override public void exitCircleTimes(FoxySheepParser.CircleTimesContext ctx) {
		flatten(ctx);
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>CenterDot[expr1,expr2]		e.e.e</p>
	 */
	@Override public void exitCenterDot(FoxySheepParser.CenterDotContext ctx) {
		flatten(ctx);
	}
	
	/**
	 * {@inheritDoc}
	 *
	 * <p>Times[expr1,expr2]</p>
	 */
	@Override public void exitTimes(FoxySheepParser.TimesContext ctx) {
		//We need to flatten over both Times and implicit Times. So
		//flatten() isn't going to cut it because sometimes there is 
		//no operator.
		
		//If the child isn't the same construct, nothing to do.
		if(	!(ctx.getChild(0) instanceof FoxySheepParser.TimesContext) )	return;
		
		ParserRuleContext lhs = (ParserRuleContext)ctx.expr(0);
		ParseTree rhs = ctx.expr(1);
		
		//Clear all children.
		ctx.children.clear();

		//Add all children of lhs. (Also adds the operator of the lhs.)
		ctx.children.addAll(  lhs.children  );

		//Finally, add the rhs back in.
		ctx.children.add(rhs);
	}
	
	/**
	 * {@inheritDoc}
	 *
	 * <p>Star[expr1,expr2]</p>
	 */
	@Override public void exitStar(FoxySheepParser.StarContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>VerticalTilde[expr1,expr2]</p>
	 */
	@Override public void exitVerticalTilde(FoxySheepParser.VerticalTildeContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>Coproduct[expr1,expr2]</p>
	 */
	@Override public void exitCoproduct(FoxySheepParser.CoproductContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>Cap[expr1,expr2]</p>
	 */
	@Override public void exitCap(FoxySheepParser.CapContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>Cup[expr1,expr2]</p>
	 */
	@Override public void exitCup(FoxySheepParser.CupContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>CirclePlus[expr1,expr2]</p>
	 */
	@Override public void exitCirclePlus(FoxySheepParser.CirclePlusContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>PlusOp[expr1,expr2]</p>
	 */
	@Override public void exitPlusOp(FoxySheepParser.PlusOpContext ctx) {
		/* We have to treat PlusOp special, because we only flatten if the operator
		 * is the same, and we also have to keep the operators intact. Also, only 
		 * plus and minus (not PlusMinus or MinusPlus) are flat.
		 */
		/* Since ANTLR4 parses this operator as left associative, we only
		 * need to check the left hand side expr.
		 */
		
		//If the child isn't a PlusOp, nothing to do.
		if(!(ctx.getChild(0) instanceof FoxySheepParser.PlusOpContext)) return;
		//If the op isn't Plus or Minus, nothing to do.
		if( ctx.BINARYMINUS()==null && ctx.BINARYPLUS()==null ) return;
		
		FoxySheepParser.PlusOpContext lhs = (FoxySheepParser.PlusOpContext)ctx.getChild(0);
		ParseTree rhs = ctx.getChild(2);
		TerminalNode op = (TerminalNode)ctx.getChild(1);
		
		//If the operator of the nested PlusOp isn't the same, nothing to do.
		if(  !op.getText().equals(lhs.getChild(1).getText()) ) return;
		
		//Clear all children.
		ctx.children.clear();

		//Add all children of lhs. (Also adds the operator of the lhs.)
		ctx.children.addAll(  lhs.children  );

		//Finally, add the rhs back in.
		ctx.children.add(rhs);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>Intersection[expr1,expr2]</p>
	 */
	@Override public void exitIntersection(FoxySheepParser.IntersectionContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>Union[expr1,expr2]</p>
	 */
	@Override public void exitUnion(FoxySheepParser.UnionContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>VerticalBar[expr1,expr2]</p>
	 */
	@Override public void exitVerticalBar(FoxySheepParser.VerticalBarContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>Same[expr1,expr2]</p>
	 */
	@Override public void exitSame(FoxySheepParser.SameContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>SetContainment[expr1,expr2]</p>
	 */
	@Override public void exitSetContainment(FoxySheepParser.SetContainmentContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>And[expr1,expr2]</p>
	 */
	@Override public void exitAnd(FoxySheepParser.AndContext ctx) {
		//The usual flatten function won't work, because there are two And operators,
		//and we need to flatten over both.
		
		//If the child isn't the same construct, nothing to do.
		if(!(ctx.getChild(0).getClass() == ctx.getClass())) return;
		
		ParserRuleContext lhs = (ParserRuleContext)ctx.getChild(0);
		ParseTree rhs = ctx.getChild(2);
		TerminalNode op = (TerminalNode)ctx.getChild(1);
		
		/*If the operator of the nested Context isn't the same, nothing to do.
		 *The operator is always in position 1 for infix operators. We do this
		 *check because some Contexts that use the same context for multiple
		 *operators.
		*/
		//Here's the part that's different from flatten().
		//If childOp is an Nand or parentOp is a Nand, then we need child==parent.
		String childOp = lhs.getChild(1).getText();
		if(childOp.equals("\u22bc") || op.getText().equals("\u22bc")){
			if(  !op.getText().equals(childOp) ) return;
		}
		
		//Clear all children.
		ctx.children.clear();

		//Add all children of lhs. (Also adds the operator of the lhs.)
		ctx.children.addAll(  lhs.children  );

		//Finally, add the rhs back in.
		ctx.children.add(rhs);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>Or[expr1,expr2]</p>
	 */
	@Override public void exitOr(FoxySheepParser.OrContext ctx) {
		//The usual flatten function won't work, because there are two Or operators,
		//and we need to flatten over both.
		
		//If the child isn't the same construct, nothing to do.
		if(!(ctx.getChild(0).getClass() == ctx.getClass())) return;
		
		ParserRuleContext lhs = (ParserRuleContext)ctx.getChild(0);
		ParseTree rhs = ctx.getChild(2);
		TerminalNode op = (TerminalNode)ctx.getChild(1);
		
		/*If the operator of the nested Context isn't the same, nothing to do.
		 *The operator is always in position 1 for infix operators. We do this
		 *check because some Contexts that use the same context for multiple
		 *operators.
		*/
		//Here's the part that's different from flatten().
		//If childOp is an Nor or parentOp is a Nor, then we need child==parent.
		String childOp = lhs.getChild(1).getText();
		if(childOp.equals("\u22bd") || op.getText().equals("\u22bd")){
			if(  !op.getText().equals(childOp) ) return;
		}
		
		//Clear all children.
		ctx.children.clear();

		//Add all children of lhs. (Also adds the operator of the lhs.)
		ctx.children.addAll(  lhs.children  );

		//Finally, add the rhs back in.
		ctx.children.add(rhs);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>Or[expr1,expr2]</p>
	 */
	@Override public void exitXor(FoxySheepParser.XorContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>Equivalent[expr1,expr2]</p>
	 */
	@Override public void exitEquivalent(FoxySheepParser.EquivalentContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>Alternatives[expr1,expr2]</p>
	 */
	@Override public void exitAlternatives(FoxySheepParser.AlternativesContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>StringExpression[expr1,expr2]</p>
	 */
	@Override public void exitStringExpression(FoxySheepParser.StringExpressionContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>Colon[expr1,expr2]</p>
	 */
	@Override public void exitColon(FoxySheepParser.ColonContext ctx) {
		flatten(ctx);
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>VerticalSeparator[expr1,expr2]</p>
	 */
	@Override public void exitVerticalSeparator(FoxySheepParser.VerticalSeparatorContext ctx) {
		flatten(ctx);
	}

}