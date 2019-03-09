package xxung.todo.service;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import xxung.todo.dao.TodoDAO;

@Service("todoService")
public class TodoServiceImpl implements TodoService {
	@Resource(name="todoDAO")
    private TodoDAO todoDAO;

    Logger log = Logger.getLogger(this.getClass());
    
}