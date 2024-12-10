package com.github.jamesnetherton.zulip.client.api.narrow;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

/**
 * A narrow is a set of filters for Zulip messages.
 *
 * @see <a href="https://zulip.com/api/construct-narrow">https://zulip.com/api/construct-narrow</a>
 */
public class Narrow {

    @JsonProperty
    private final String operator;

    @JsonProperty
    private final Object operand;

    @JsonProperty
    private final boolean negated;

    /**
     * Constructs a {@link Narrow} with a String operand.
     *
     * @param operator The operator that the narrow will apply to
     * @param operand  The operand that the narrow will apply to
     * @param negated  Whether the narrow is negated
     */
    public Narrow(String operator, String operand, boolean negated) {
        this(operator, (Object) operand, negated);
    }

    /**
     * Constructs a {@link Narrow} with an Integer operand.
     *
     * @param operator The operator that the narrow will apply to
     * @param operand  The operand that the narrow will apply to
     * @param negated  Whether the narrow is negated
     */
    public Narrow(String operator, Integer operand, boolean negated) {
        this(operator, (Object) operand, negated);
    }

    /**
     * Constructs a {@link Narrow} with an Long operand.
     *
     * @param operator The operator that the narrow will apply to
     * @param operand  The operand that the narrow will apply to
     * @param negated  Whether the narrow is negated
     */
    public Narrow(String operator, Long operand, boolean negated) {
        this(operator, (Object) operand, negated);
    }

    /**
     * Constructs a {@link Narrow} with an numeric List operand.
     *
     * @param operator The operator that the narrow will apply to
     * @param operand  The operand that the narrow will apply to
     * @param negated  Whether the narrow is negated
     */
    public Narrow(String operator, List<? extends Number> operand, boolean negated) {
        this(operator, (Object) operand, negated);
    }

    private Narrow(String operator, Object operand, boolean negated) {
        this.operator = operator;
        this.operand = operand;
        this.negated = negated;
    }

    /**
     * Creates a {@link Narrow}.
     *
     * @param  operator The operator that the narrow will apply to
     * @param  operand  The operand that the narrow will apply to
     * @return          The {@link Narrow} constructed from the operator and operand
     */
    public static Narrow of(String operator, String operand) {
        return new Narrow(operator, operand, false);
    }

    /**
     * Creates a {@link Narrow}.
     *
     * @param  operator The operator that the narrow will apply to
     * @param  operand  The operand that the narrow will apply to
     * @return          The {@link Narrow} constructed from the operator and operand
     */
    public static Narrow of(String operator, Integer operand) {
        return new Narrow(operator, operand, false);
    }

    /**
     * Creates a {@link Narrow}.
     *
     * @param  operator The operator that the narrow will apply to
     * @param  operand  The operand that the narrow will apply to
     * @return          The {@link Narrow} constructed from the operator and operand
     */
    public static Narrow of(String operator, Long operand) {
        return new Narrow(operator, operand, false);
    }

    /**
     * Creates a {@link Narrow}.
     *
     * @param  operator The operator that the narrow will apply to
     * @param  operand  The operand that the narrow will apply to
     * @return          The {@link Narrow} constructed from the operator and operand
     */
    public static Narrow of(String operator, List<? extends Number> operand) {
        return new Narrow(operator, operand, false);
    }

    /**
     * Creates a negated {@link Narrow}.
     *
     * @param  operator The operator that the narrow will apply to
     * @param  operand  The operand that the narrow will apply to
     * @return          The negated {@link Narrow} constructed from the operator and operand
     */
    public static Narrow ofNegated(String operator, String operand) {
        return new Narrow(operator, operand, true);
    }

    public String getOperator() {
        return operator;
    }

    public Object getOperand() {
        return operand;
    }

    public boolean isNegated() {
        return negated;
    }
}
