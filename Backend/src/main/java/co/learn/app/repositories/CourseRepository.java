package co.learn.app.repositories;

import co.learn.app.entities.Course;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CourseRepository extends JpaRepository<Course, Long> {
    java.util.List<Course> findByCreator_Id(Long userId);
}