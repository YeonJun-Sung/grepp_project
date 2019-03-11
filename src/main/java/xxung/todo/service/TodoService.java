package xxung.todo.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service
public interface TodoService {
	List<Map<String, Object>> getTodoList(int offset) throws Exception;
	int getPaging() throws Exception;
	void saveTodoList(Map<String, Object> param) throws Exception;
	Map<String, Object> getTodoDetail(String list_key) throws Exception;
	void completeTodo(String list_key) throws Exception;
	void deleteTodo(String list_key) throws Exception;
	void createTodoList(Map<String, Object> param) throws Exception;
	void addPriority(Map<String, Object> param) throws Exception;
	void orderPriority(int num) throws Exception;
	int getMaxPriority() throws Exception;
	void removePriority(String list_key) throws Exception;
}