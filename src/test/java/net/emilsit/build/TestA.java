package net.emilsit.build;

import org.junit.Test;
import static org.junit.Assert.*;

public class TestA {
    @Test
    public void makeA() {
        int v = 5;
        final A a = new A(v);
        assertEquals("int wrapper get", v, a.get());
    }
}
